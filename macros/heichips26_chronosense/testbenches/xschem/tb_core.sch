v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 110 -50 200 -50 {lab=#net1}
N -250 -90 -190 -90 {lab=#net2}
N 200 20 200 40 {lab=0}
N 110 -30 140 -30 {lab=0}
N 140 -30 140 -20 {lab=0}
N -250 -30 -250 -10 {lab=0}
N 110 -70 250 -70 {lab=#net3}
N 310 -70 310 20 {lab=0}
N 200 20 310 20 {lab=0}
N 200 10 200 20 {lab=0}
N 110 -90 150 -90 {lab=out}
C {chronosense_core.sym} -40 -60 0 0 {name=x1}
C {vsource.sym} -250 -60 0 0 {name=V2 value=0.6 savecurrent=false}
C {vsource.sym} 200 -20 0 0 {name=V3 value=1.2 savecurrent=false}
C {res.sym} 280 -70 3 0 {name=R1
value=10k
footprint=1206
device=resistor
m=1}
C {gnd.sym} -250 -10 0 0 {name=l1 lab=0}
C {gnd.sym} 140 -20 0 0 {name=l2 lab=0}
C {gnd.sym} 200 40 0 0 {name=l3 lab=0}
C {code.sym} 20 110 0 0 {name=s1 only_toplevel=false value="
.lib $PDKPATH/libs.tech/ngspice/models/cornerMOSlv.lib mos_tt
.lib $PDKPATH/libs.tech/ngspice/models/cornerRES.lib res_typ
.lib $PDKPATH/libs.tech/ngspice/models/cornerCAP.lib cap_typ
.param VDD=1.2 VREF=0.6 CT=15p
.ic v(x1.ctn)=0.5
.options method=gear reltol=1e-4 itl4=100
.tran 50p 3u
.control
run
meas tran t20  TRIG v(out) VAL=0.6 RISE=5 TARG v(out) VAL=0.6 RISE=25
let tper = t20/20
print tper
.endc
"}
C {lab_pin.sym} 150 -90 0 1 {name=p1 sig_type=std_logic lab=out}
