#!/bin/bash
# ChronoSense-1 testbench run.
#
#   ./architecturedef_pvt.sh 0         Schmitt trip points
#   ./architecturedef_pvt.sh 1         architecture screen (D1/I1/I2)
#   ./architecturedef_pvt.sh 2 I1      PVT on one variant
#
# Notes on a few things:
#   - The schmitt subckt ends in a buffer inverter, so v(out) is non-inverting. RISE gives VTH+, FALL gives VTH- had these swapped for a while.
#   - Sim window scales with R. A fixed 25us/100ps was overkill for small R and too short for large R.
#   - Measure in the last fifth of the run, after the oscillator settles.
#   - BETA = 3950 per the NTC datasheet.
#   - Environment = IIC-OSIC-TOOL

set +e

PHASE="${1:-all}"
WINNER="${2:-I2}"
OUT=g1
JOBS=4 #just my cpu cores, feel free to change, though you mght endup modifying a few other things
RS="1760 4700 10000 22000 33600 47000"
LIB='.lib "$PDKPATH/libs.tech/ngspice/models/cornerMOSlv.lib" __CORNER__'

mkdir -p $OUT

# Reusable cells. IHP port order is (d g s b) confirm with:
#   grep -A2 "subckt sg13_lv_pmos" $PDKPATH/libs.ref/sg13g2_pr/spice/*.lib.spice
read -r -d '' COMMON << 'EOF'
.subckt inv out in vdd vss
XP out in vdd vdd sg13_lv_pmos w=2u l=0.35u
XN out in vss vss sg13_lv_nmos w=1u l=0.35u
.ends

* Schmitt trigger. MN3/MP3 set the hysteresis width. Widen them if
* VTH+ minus VTH- comes out too small.
.subckt schmitt out in vdd vss
XMN1 x    in   vss  vss sg13_lv_nmos w=3u  l=0.35u
XMN2 outi in   x    vss sg13_lv_nmos w=3u  l=0.35u
XMN3 vdd  outi x    vss sg13_lv_nmos w=3u  l=0.35u
XMP1 y    in   vdd  vdd sg13_lv_pmos w=6u  l=0.35u
XMP2 outi in   y    vdd sg13_lv_pmos w=6u  l=0.35u
XMP3 vss  outi y    vdd sg13_lv_pmos w=6u  l=0.35u
XBUF out outi vdd vss inv
.ends
EOF

phase0 () {
  echo "Schmitt trip points (tt, 1.2V, 27C)"
  cat > $OUT/schmitt_dc.spice << EOF
$(echo "$LIB" | sed 's/__CORNER__/mos_tt/')
.param VDD=1.2
Vdd vdd 0 {VDD}
Vss vss 0 0
Vin in 0 PWL(0 0 50u 1.2 100u 0)
XS out in vdd vss schmitt
$COMMON
.tran 10n 100u
.control
run
meas tran vthp FIND v(in) WHEN v(out)=0.6 RISE=1
meas tran vthm FIND v(in) WHEN v(out)=0.6 FALL=1
let hyst = vthp - vthm
print vthp vthm hyst
quit
.endc
.end
EOF
  ngspice -b $OUT/schmitt_dc.spice 2>&1 | tee $OUT/schmitt_dc.log | \
    grep -Ei "vthp|vthm|hyst|error|failed|unknown"
  echo ""
  echo "vthp = upper trip, vthm = lower trip. hyst is what the cap swings."
  echo "If hyst < 0.25 V, widen MN3/MP3 (try 5u/10u) and rerun."
  echo "If vthp and vthm come out swapped, flip RISE/FALL above."
}

gen_netlist () {
  # $1=variant $2=R $3=corner $4=vdd $5=temp $6=outfile
  local V=$1 R=$2 CORNER=$3 VD=$4 TEMP=$5 F=$6

  # Sim window and step scale with R. Period is roughly proportional to R,
  # so small R needs shorter runs. Measure in the last ~20% of the window.
  local TSTOP TMAX MFROM MTO TH
  TSTOP=$(awk "BEGIN{t=0.5e-9*$R; if(t<2e-6)t=2e-6; printf \"%.4g\",t}")
  TMAX=$(awk "BEGIN{t=2.7e-14*$R; if(t<2e-11)t=2e-11; if(t>5e-10)t=5e-10; printf \"%.4g\",t}")
  MFROM=$(awk "BEGIN{printf \"%.4g\", 0.60*$TSTOP}")
  MTO=$(awk "BEGIN{printf \"%.4g\", 0.80*$TSTOP}")
  TH=$(awk "BEGIN{printf \"%.4g\", $VD/2}")

  {
    echo "* ChronoSense G1  variant=$V R=$R corner=$CORNER vdd=$VD temp=$TEMP"
    echo "$LIB" | sed "s/__CORNER__/$CORNER/"
    echo ".param VDD=$VD CT=15p"
    echo ".temp $TEMP"
    echo "Vdd vdd 0 {VDD}"
    echo "Vss vss 0 0"

    case $V in
      D1)
        # diode input -- the baseline failure. Pad voltage droops
        # as sensor current increases, which makes T vs R nonlinear.
        cat << EOF
Rext pad 0 $R
XPDI pad pad vdd vdd sg13_lv_pmos w=5u   l=0.5u
XPMI ctn pad vdd vdd sg13_lv_pmos w=7.5u l=0.5u
CT ctn vss {CT}
XRST ctn sch vss vss sg13_lv_nmos w=10u l=0.35u
XSCH sch ctn vdd vss schmitt
EOF
        ;;
      I1)
        # ideal V-to-I (fixed pad voltage), still has the reset NMOS
        cat << EOF
Vpad pad 0 $TH
Rext pad 0 $R
Bmir vss ctn I = { 1.5 * abs(i(Vpad)) }
CT ctn vss {CT}
XRST ctn sch vss vss sg13_lv_nmos w=10u l=0.35u
XSCH sch ctn vdd vss schmitt
EOF
        ;;
      I2)
        # dual slope -- current reverses with the Schmitt state, no reset.
        # In theory no dead time, in practice overshoot varies with current.
        cat << EOF
Vpad pad 0 $TH
Rext pad 0 $R
Bmir vss ctn I = { (V(sch) < $TH) ? 1.5*abs(i(Vpad)) : -1.5*abs(i(Vpad)) }
CT ctn vss {CT}
XSCH sch ctn vdd vss schmitt
EOF
        ;;
    esac

    cat << EOF
XINV1 schb sch  vdd vss inv
XINV2 out  schb vdd vss inv
$COMMON
.ic v(ctn)=$TH
.options method=gear reltol=1e-4 vntol=1e-7 abstol=1e-13
.tran $TMAX $TSTOP 0 $TMAX
.control
run
* 20 periods, edge 5 to edge 25
meas tran t20 TRIG v(out) VAL=$TH RISE=5 TARG v(out) VAL=$TH RISE=25
* cap swing -- if this varies a lot across R, something is wrong
meas tran vmax MAX v(ctn) FROM=$MFROM TO=$MTO
meas tran vmin MIN v(ctn) FROM=$MFROM TO=$MTO
meas tran vpd  AVG v(pad) FROM=$MFROM TO=$MTO
echo "SWEEP_RESULT $V $CORNER $VD $TEMP $R \$&t20 \$&vmax \$&vmin \$&vpd"
quit
.endc
.end
EOF
  } > "$F"
}

phase1 () {
  echo "Architecture screen (tt, 1.2V, 27C)"
  for v in D1 I1 I2; do
    mkdir -p $OUT/p1/$v
    for r in $RS; do
      gen_netlist $v $r mos_tt 1.2 27 $OUT/p1/$v/r_$r.spice
    done
    ls $OUT/p1/$v/r_*.spice | xargs -P $JOBS -I {} bash -c 'ngspice -b {} > {}.log 2>&1'
    echo "  $v done"
  done
  grep -h SWEEP_RESULT $OUT/p1/*/*.log > $OUT/p1_results.txt
  echo ""
  for v in D1 I1 I2; do
    echo "  $v failures: $(grep -l 'failed!' $OUT/p1/$v/*.log 2>/dev/null | wc -l) of 6"
  done
  analyse $OUT/p1_results.txt
}

phase2 () {
  local V=$1
  echo "PVT sweep on $V (3 corners x 3 supplies x 3 temps)"
  mkdir -p $OUT/p2
  for corner in mos_tt mos_ss mos_ff; do
    for vd in 1.08 1.20 1.32; do
      for tmp in -40 27 85; do
        tag="${corner}_${vd}_${tmp}"
        mkdir -p $OUT/p2/$tag
        for r in $RS; do
          gen_netlist $V $r $corner $vd $tmp $OUT/p2/$tag/r_$r.spice
        done
      done
    done
  done
  ls $OUT/p2/*/r_*.spice | xargs -P $JOBS -I {} bash -c 'ngspice -b {} > {}.log 2>&1'
  grep -h SWEEP_RESULT $OUT/p2/*/*.log > $OUT/p2_results.txt
  echo "  $(wc -l < $OUT/p2_results.txt) of 162 runs returned"
  echo "  failures: $(grep -l 'failed!' $OUT/p2/*/*.log 2>/dev/null | wc -l)"
  analyse $OUT/p2_results.txt
}

# Python analysis: group by (variant, corner, vdd, temp), fit T = aR + b
# from the endpoints, report worst residual in ppmFS and equivalent °C.
analyse () {
  python3 - "$1" << 'PYEOF'
import sys, collections
rows = collections.defaultdict(list)
for ln in open(sys.argv[1]):
    p = ln.split()
    if len(p) < 10 or p[0] != "SWEEP_RESULT":
        continue
    try:
        v, c, vd, t, R = p[1], p[2], p[3], p[4], float(p[5])
        t20, vmax, vmin, vpd = (float(x) for x in p[6:10])
    except ValueError:
        continue
    if t20 <= 0:
        continue
    rows[(v, c, vd, t)].append((R, t20/20.0, vmax, vmin, vpd))

BETA, T0 = 3950.0, 298.15
K_DEGC = (T0*T0)/BETA

print(f"\n{'config':26} {'ns/kohm':>9} {'icpt ns':>9} {'dV mV':>8} "
      f"{'dV spr%':>8} {'2pt ppmFS':>10} {'degC':>7} {'n':>3}")
print("-"*90)

summary = []
for key in sorted(rows):
    d = sorted(rows[key])
    tag = "/".join(key)
    if len(d) < 3:
        print(f"{tag:26}   INCOMPLETE ({len(d)} of 6)")
        continue
    Rs  = [x[0] for x in d]
    Ts  = [x[1] for x in d]
    dVs = [x[2]-x[3] for x in d]

    # two-point cal anchored at the endpoints
    a = (Ts[-1]-Ts[0])/(Rs[-1]-Rs[0])
    b = Ts[0] - a*Rs[0]
    res = [Ts[i] - (a*Rs[i]+b) for i in range(len(Rs))]
    span = Ts[-1]-Ts[0]
    worst = max(res, key=abs)
    ppm_fs = abs(worst)/span*1e6 if span else float('nan')

    # period error -> R error -> °C error
    dR_over_R = abs(worst)/a / Rs[res.index(worst)]
    degC = K_DEGC * dR_over_R
    dv_avg = sum(dVs)/len(dVs)
    dv_spread = (max(dVs)-min(dVs))/dv_avg*100 if dv_avg else float('nan')

    print(f"{tag:26} {a*1e12:9.3f} {b*1e9:9.1f} {dv_avg*1e3:8.1f} "
          f"{dv_spread:8.2f} {ppm_fs:10.0f} {degC:7.3f} {len(d):3d}")
    summary.append((a, ppm_fs, degC))

if len(summary) > 1:
    sl = [s[0] for s in summary]
    print("-"*90)
    print(f"slope spread: {(max(sl)-min(sl))/(sum(sl)/len(sl))*100:.2f}%")
    print(f"worst linearity: {max(s[1] for s in summary):.0f} ppmFS "
          f"({max(s[2] for s in summary):.3f} degC)")
PYEOF
}

case "$PHASE" in
  0)   phase0 ;;
  1)   phase1 ;;
  2)   phase2 "$WINNER" ;;
  3)   analyse "$WINNER" ;;
  all) phase0; phase1; echo ""; echo "then: $0 2 <winner>" ;;
  *)   echo "usage: $0 {0|1|2 <variant>|all}" ;;
esac
