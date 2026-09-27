#!/usr/bin/env python3
"""
ChronoSense-1 PVT harness for the transistor-level core.
Reads the xschem-exported tb_core.spice, generates one netlist per (corner, vdd, temp, R) point,
runs them in batch, and reports linearity.
"""
import argparse, os, re, subprocess, sys, time
from concurrent.futures import ThreadPoolExecutor
from collections import defaultdict

SRC       = "tb_core.spice"
OUTDIR    = "pvt"
RVALS     = [1760, 4700, 10000, 22000, 33600, 47000]
CORNERS   = ["mos_tt", "mos_ss", "mos_ff"]
VDDS      = [1.08, 1.20, 1.32]
TEMPS     = [-40, 27, 85]
BETA, T0  = 3950.0, 298.15
TIMEOUT   = 300

# node names from xschem. update if the schematic is re-netlisted.
N_OUT, N_CTN, N_PAD = "out", "x1.ctn", "net3"

def build(corner, vdd, temp, R, res="res_typ", cap="cap_typ"):
    """Return the full text of one independent netlist."""
    txt = open(SRC).read()

    # every subn asserts one match, so a format change fails loudly
    txt, n = re.subn(r"(?m)^R1\s+net3\s+0\s+\S+\s*$", f"R1 net3 0 {R}", txt)
    assert n == 1, f"sense resistor R1 matched {n} times"

    txt, n = re.subn(r"(?m)^(\.lib\s+\S*cornerMOSlv\.lib\s+)\S+", rf"\g<1>{corner}", txt)
    assert n == 1, f"MOS corner matched {n} times"

    txt, n = re.subn(r"(?m)^(\.lib\s+\S*cornerRES\.lib\s+)\S+", rf"\g<1>{res}", txt)
    assert n == 1, "RES corner not set"

    txt, n = re.subn(r"(?m)^(\.lib\s+\S*cornerCAP\.lib\s+)\S+", rf"\g<1>{cap}", txt)
    assert n == 1, "CAP corner not set"

    txt, n = re.subn(r"(?m)^(\.param\s+VDD=)\S+", rf"\g<1>{vdd}", txt)
    assert n == 1, "VDD not set"

    # *** NEW: actually change the voltage source that sets the supply ***
    txt, n = re.subn(r"(?m)^V3\s+\S+\s+0\s+\S+\s*$", f"V3 net1 0 {vdd}", txt)
    assert n == 1, "supply source V3 not set"

    # Optional: if you decide VREF should track VDD/2, uncomment the next two lines
    # txt, n = re.subn(r"(?m)^V2\s+\S+\s+0\s+\S+\s*$", f"V2 net2 0 {vdd/2}", txt)
    # assert n == 1, "VREF source V2 not set"

    txt = re.sub(r"(?m)^\.ic\s+.*$", f".ic v({N_CTN})={vdd/2:.4f}", txt)
    txt = re.sub(r"(?m)^\.param\s+VDD=", f".temp {temp}\n.param VDD=", txt, count=1)

    # period scales with R, so scale the window and the max step with it
    tstop = max(0.3e-9 * R, 1e-6)                          # 25+ periods, floor 1 us
    tmax  = min(max(2.7e-14 * R, 20e-12), 500e-12)         # few hundred pts per period
    txt, n = re.subn(r"(?m)^\.tran\s+.*$", f".tran {tmax:.4g} {tstop:.4g} 0 {tmax:.4g}", txt)
    assert n == 1, ".tran not set"

    th  = vdd / 2
    mf, mt = 0.60 * tstop, 0.80 * tstop
    ctl = f""".control
run
meas tran t20  TRIG v({N_OUT}) VAL={th:.4f} RISE=5 TARG v({N_OUT}) VAL={th:.4f} RISE=25
meas tran vmax MAX v({N_CTN}) FROM={mf:.4g} TO={mt:.4g}
meas tran vmin MIN v({N_CTN}) FROM={mf:.4g} TO={mt:.4g}
meas tran vpad AVG v({N_PAD}) FROM={mf:.4g} TO={mt:.4g}
echo "PVT {corner} {vdd} {temp} {res} {cap} {R} $&t20 $&vmax $&vmin $&vpad"
quit
.endc"""
    txt, n = re.subn(r"(?ms)^\.control.*?^\.endc", ctl, txt)
    assert n == 1, f".control block matched {n} times"
    return txt


def run_one(job):
    corner, vdd, temp, R, res, cap = job
    tag = f"{corner}_{vdd}_{temp}_{res}_{cap}"
    d   = os.path.join(OUTDIR, tag)
    os.makedirs(d, exist_ok=True)
    f   = os.path.join(d, f"r_{R}.spice")
    open(f, "w").write(build(corner, vdd, temp, R, res, cap))

    env = dict(os.environ, OMP_NUM_THREADS="1", OPENBLAS_NUM_THREADS="1",
               MKL_NUM_THREADS="1")
    t0 = time.time()
    try:
        subprocess.run(["ngspice", "-b", "-o", f + ".log", f],
                       timeout=TIMEOUT, env=env)
        with open(f + ".log", "r") as log_file:
            line = next((l for l in log_file if l.startswith("PVT ")), None)
    except subprocess.TimeoutExpired:
        with open(f + ".log", "w") as log_file:
            log_file.write("KILLED BY TIMEOUT\n")
        line = None
    return line, time.time() - t0, f


def analyse(path):
    rows = defaultdict(list)
    kept = dropped = 0
    for ln in open(path):
        p = ln.split()
        if len(p) < 11 or p[0] != "PVT":
            continue
        try:
            key = (p[1], p[2], p[3], p[4], p[5])
            R = float(p[6]); t20, vmax, vmin, vpad = (float(x) for x in p[7:11])
        except ValueError:
            dropped += 1; continue
        if t20 <= 0 or vmax <= vmin:
            dropped += 1; continue
        rows[key].append((R, t20 / 20.0, vmax, vmin, vpad))
        kept += 1

    K = (T0 * T0) / BETA
    print(f"\nvalid points {kept}, rejected {dropped}\n")
    print(f"{'corner/vdd/temp/res/cap':34} {'ns/kohm':>9} {'icpt ns':>8} "
          f"{'dV mV':>7} {'dV spr%':>8} {'vpad mV':>8} {'ppmFS':>8} {'degC':>7} {'n':>3}")
    print("." * 104)

    summary, incomplete = [], []
    for key in sorted(rows):
        d = sorted(rows[key]); tag = "/".join(key)
        if len(d) < len(RVALS):
            incomplete.append((tag, len(d)))
        if len(d) < 3:
            print(f"{tag:34}   INCOMPLETE, {len(d)} of {len(RVALS)} points")
            continue
        Rs  = [x[0] for x in d]; Ts = [x[1] for x in d]
        dVs = [x[2] - x[3] for x in d]; vps = [x[4] for x in d]
        a = (Ts[-1] - Ts[0]) / (Rs[-1] - Rs[0])
        b = Ts[0] - a * Rs[0]
        res_ns = [Ts[i] - (a * Rs[i] + b) for i in range(len(Rs))]
        span   = Ts[-1] - Ts[0]
        worst  = max(res_ns, key=abs)
        ppm    = abs(worst) / span * 1e6
        degC   = K * (abs(worst) / a) / Rs[res_ns.index(worst)]
        dv_avg = sum(dVs) / len(dVs)
        print(f"{tag:34} {a*1e12:9.3f} {b*1e9:8.1f} {dv_avg*1e3:7.1f} "
              f"{(max(dVs)-min(dVs))/dv_avg*100:8.2f} {(max(vps)-min(vps))*1e3:8.2f} "
              f"{ppm:8.0f} {degC:7.3f} {len(d):3d}")
        summary.append((tag, a, b, ppm, degC))

    if summary:
        sl = [s[1] for s in summary]
        print("." * 104)
        print(f"slope spread, gain, cancels in the ratio : "
              f"{(max(sl)-min(sl))/(sum(sl)/len(sl))*100:.2f} %")
        wt, _, _, wp, wd = max(summary, key=lambda s: s[4])
        print(f"worst linearity, does not cancel         : {wp:.0f} ppmFS, "
              f"{wd:.3f} degC at {wt}")
        bo = max(summary, key=lambda s: abs(s[2] / s[1]))
        print(f"largest phantom resistance               : "
              f"{bo[2]/bo[1]/1000:.2f} kohm at {bo[0]}")
        print("\nNOTE degC uses NTC sensitivity at 25 C. The NTC is less sensitive "
              "hot, so\nread the worst case as up to 1.3x larger.")

    if incomplete:
        print(f"\nINCOMPLETE CONFIGS ({len(incomplete)}). Their calibration anchors "
              "moved, so\ntheir numbers are not comparable with the rest.")
        for tag, n in incomplete:
            print(f"  {tag}  ({n}/{len(RVALS)})")

    csv = os.path.join(OUTDIR, "summary.csv")
    with open(csv, "w") as fh:
        fh.write("config,slope_ns_per_kohm,intercept_ns,ppmFS,degC\n")
        for tag, a, b, ppm, dc in summary:
            fh.write(f"{tag},{a*1e12:.4f},{b*1e9:.3f},{ppm:.1f},{dc:.4f}\n")
    print(f"\nwrote {csv}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--jobs", type=int, default=4)
    ap.add_argument("--probe", action="store_true")
    ap.add_argument("--rescap", action="store_true")
    ap.add_argument("--analyze")
    a = ap.parse_args()

    if a.analyze:
        analyse(a.analyze); return
    if not os.path.exists(SRC):
        sys.exit(f"{SRC} not found, run from the directory holding it")
    os.makedirs(OUTDIR, exist_ok=True)

    if a.probe:
        line, dt, f = run_one(("mos_tt", 1.20, 27, 10000, "res_typ", "cap_typ"))
        print(f"one run: {dt:.1f} s")
        print(f"result : {line or 'NO RESULT, inspect ' + f + '.log'}")
        if line:
            n = len(RVALS) * len(CORNERS) * len(VDDS) * len(TEMPS)
            print(f"\n{n} runs / {a.jobs} jobs is about {n*dt/a.jobs/60:.0f} min")
            print("If the real batch runs much longer, it is the harness, not the "
                  "circuit.\nKill it and rerun with --jobs 1.")
        return

    jobs = [(c, v, t, R, "res_typ", "cap_typ")
            for c in CORNERS for v in VDDS for t in TEMPS for R in RVALS]
    if a.rescap:
        for res, cap in (("res_bcs", "cap_bcs"), ("res_wcs", "cap_wcs")):
            jobs += [("mos_tt", 1.20, 27, R, res, cap) for R in RVALS]

    print(f"{len(jobs)} runs, {a.jobs} parallel, {TIMEOUT} s timeout each")
    t0, done, killed, results = time.time(), 0, 0, []

    with ThreadPoolExecutor(max_workers=a.jobs) as ex:
        for line, dt, f in ex.map(run_one, jobs):
            done += 1
            if line:
                results.append(line)
            else:
                killed += 1
                if killed <= 3:
                    print(f"  no result: {f}")
            if done % 18 == 0:
                print(f"  {done}/{len(jobs)}  {time.time()-t0:.0f} s elapsed, "
                      f"{len(results)} results")

    rp = os.path.join(OUTDIR, "results.txt")
    open(rp, "w").write("\n".join(results) + "\n")
    print(f"\n{len(results)}/{len(jobs)} produced results in "
          f"{(time.time()-t0)/60:.1f} min, wrote {rp}")
    if killed:
        print(f"{killed} runs gave no result. If that equals the run count, every run "
              "was\nkilled. Check whether total time is timeout x batches before "
              "blaming the\ncircuit.")
    analyse(rp)


if __name__ == "__main__":
    main()
