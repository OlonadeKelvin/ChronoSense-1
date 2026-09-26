v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -220 180 -220 230 {lab=y}
N -220 110 -220 120 {lab=vdd}
N -220 -200 -220 -180 {lab=vss}
N -220 -120 -220 -80 {lab=x}
N -300 -150 -260 -150 {lab=in}
N -300 -150 -300 -50 {lab=in}
N -300 -50 -260 -50 {lab=in}
N -300 150 -260 150 {lab=in}
N -300 150 -300 260 {lab=in}
N -300 260 -260 260 {lab=in}
N -300 -50 -300 150 {lab=in}
N -220 290 -220 310 {lab=#net1}
N -220 -20 -220 -10 {lab=#net1}
N 50 -90 50 -50 {lab=y}
N -20 -120 10 -120 {lab=#net1}
N 60 170 60 180 {lab=vss}
N 60 40 60 70 {lab=x}
N -220 -150 -190 -150 {lab=vss}
N -190 -160 -190 -150 {lab=vss}
N -220 -200 -190 -200 {lab=vss}
N -220 -50 -110 -50 {lab=vss}
N -220 150 -180 150 {lab=vdd}
N -180 110 -180 150 {lab=vdd}
N -220 110 -180 110 {lab=vdd}
N -220 260 -90 260 {lab=vdd}
N 50 -120 80 -120 {lab=vdd}
N 60 100 90 100 {lab=vss}
N 90 100 90 170 {lab=vss}
N 60 130 60 150 {lab=vdd}
N 440 -0 460 -0 {lab=out}
N 440 -20 470 -20 {lab=vdd}
N 440 20 460 20 {lab=vss}
N -20 -10 -20 100 {lab=#net1}
N -10 100 20 100 {lab=#net1}
N -20 -20 140 -20 {lab=#net1}
N -20 -120 -20 -20 {lab=#net1}
N -220 -230 -220 -200 {lab=vss}
N -220 -10 -20 -10 {lab=#net1}
N -20 -20 -20 -10 {lab=#net1}
N -220 310 -10 310 {lab=#net1}
N -10 100 -10 310 {lab=#net1}
N -20 100 -10 100 {lab=#net1}
N -90 150 -90 260 {lab=vdd}
N -220 70 -220 110 {lab=vdd}
N -220 70 -90 70 {lab=vdd}
N 80 -210 470 -210 {lab=vdd}
N 50 -250 50 -210 {lab=vdd}
N 470 -210 470 -20 {lab=vdd}
N 90 170 120 170 {lab=vss}
N 120 230 120 400 {lab=vss}
N -390 400 120 400 {lab=vss}
N -390 -230 -390 400 {lab=vss}
N -390 -230 -220 -230 {lab=vss}
N -80 -190 50 -190 {lab=vdd}
N 50 -210 50 -190 {lab=vdd}
N -80 -190 -80 70 {lab=vdd}
N -90 70 -80 70 {lab=vdd}
N -110 -160 -110 -50 {lab=vss}
N -190 -160 -110 -160 {lab=vss}
N -190 -200 -190 -160 {lab=vss}
N 460 20 460 230 {lab=vss}
N 120 230 460 230 {lab=vss}
N 120 170 120 230 {lab=vss}
N 60 170 90 170 {lab=vss}
N -90 150 60 150 {lab=vdd}
N -90 70 -90 150 {lab=vdd}
N 80 -210 80 -120 {lab=vdd}
N 50 -210 80 -210 {lab=vdd}
N 50 -170 50 -150 {lab=vss}
N -110 -170 50 -170 {lab=vss}
N -110 -170 -110 -160 {lab=vss}
C {sg13g2_pr/sg13_lv_nmos.sym} -240 -150 2 1 {name=M1
l=0.35u
w=3u
ng=1
m=1
mm_ok=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_pmos.sym} -240 150 0 0 {name=M2
l=0.35u
w=6u
ng=1
m=1
mm_ok=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_nmos.sym} -240 -50 2 1 {name=M3
l=0.35u
w=3u
ng=1
m=1
mm_ok=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_nmos.sym} 40 100 0 0 {name=M4
l=0.35u
w=3u
ng=1
m=1
mm_ok=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_pmos.sym} -240 260 0 0 {name=M5
l=0.35u
w=6u
ng=1
m=1
mm_ok=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_pmos.sym} 30 -120 0 0 {name=M6
l=0.35u
w=6u
ng=1
m=1
mm_ok=1
model=sg13_lv_pmos
spiceprefix=X
}
C {lab_pin.sym} -220 200 0 0 {name=p3 sig_type=std_logic lab=y}
C {lab_pin.sym} -220 -100 0 0 {name=p5 sig_type=std_logic lab=x}
C {ipin.sym} -300 50 0 0 {name=p6 lab=in
}
C {iopin.sym} 50 -250 1 1 {name=p9 lab=vdd
}
C {lab_pin.sym} 50 -50 0 0 {name=p10 sig_type=std_logic lab=y}
C {iopin.sym} 60 180 1 0 {name=p12 lab=vss


}
C {lab_pin.sym} 60 40 0 0 {name=p13 sig_type=std_logic lab=x}
C {inv.sym} 290 0 0 0 {name=x1}
C {opin.sym} 460 0 2 1 {name=p19 lab=out
}
