v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -140 160 -140 230 {lab=vtail}
N 100 80 100 100 {lab=vdd}
N 100 260 100 270 {lab=vdd}
N 30 130 60 130 {lab=vx}
N 30 180 30 300 {lab=vx}
N 30 300 60 300 {lab=vx}
N 100 160 100 180 {lab=vx}
N 30 180 100 180 {lab=vx}
N 30 130 30 180 {lab=vx}
N 260 170 260 200 {lab=vtail}
N 260 90 260 110 {lab=vss}
N 280 220 280 240 {lab=vb}
N 220 220 280 220 {lab=vb}
N 220 220 220 270 {lab=vb}
N 220 270 240 270 {lab=vb}
N -140 80 -140 100 {lab=vx}
N -140 290 -140 320 {lab=vout}
N -210 130 -180 130 {lab=vin}
N -210 260 -180 260 {lab=vip}
N -80 20 -80 50 {lab=vb}
N -80 -80 -80 -40 {lab=vdd}
N 280 320 280 340 {lab=vss}
N 280 270 330 270 {lab=vss}
N 330 270 330 320 {lab=vss}
N 280 320 330 320 {lab=vss}
N 280 300 280 320 {lab=vss}
N 100 300 140 300 {lab=vdd}
N 100 330 100 350 {lab=vout}
N 140 260 140 300 {lab=vdd}
N 100 260 140 260 {lab=vdd}
N 260 140 310 140 {lab=vss}
N 310 90 310 140 {lab=vss}
N 260 90 310 90 {lab=vss}
N 260 80 260 90 {lab=vss}
N 100 130 130 130 {lab=vdd}
N 130 80 130 130 {lab=vdd}
N 100 80 130 80 {lab=vdd}
N 100 70 100 80 {lab=vdd}
N -140 130 -80 130 {lab=#net1}
N -140 260 -80 260 {lab=#net2}
C {sg13g2_pr/sg13_lv_nmos.sym} -160 130 0 0 {name=M1
l=0.5u
w=5u
ng=1
m=4
mm_ok=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_pmos.sym} 80 130 0 0 {name=M3
l=1u
w=5u
ng=1
m=2
mm_ok=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_nmos.sym} -160 260 2 1 {name=M2
l=0.5u
w=5u
ng=1
m=4
mm_ok=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_nmos.sym} 260 270 0 0 {name=M6
l=0.13u
w=0.15u
ng=1
m=1
mm_ok=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_nmos.sym} 240 140 2 1 {name=M5
l=0.13u
w=0.15u
ng=1
m=1
mm_ok=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_pmos.sym} 80 300 0 0 {name=M4
l=1u
w=5u
ng=1
m=2
mm_ok=1
model=sg13_lv_pmos
spiceprefix=X
}
C {lab_pin.sym} -140 190 0 0 {name=p1 sig_type=std_logic lab=vtail
}
C {iopin.sym} 100 70 3 0 {name=p3 lab=vdd}
C {iopin.sym} 260 80 1 1 {name=p4 lab=vss
}
C {iopin.sym} 100 260 3 0 {name=p2 lab=vdd}
C {lab_pin.sym} 260 200 0 0 {name=p5 sig_type=std_logic lab=vtail
}
C {lab_pin.sym} 220 250 0 0 {name=p6 sig_type=std_logic lab=vb
}
C {lab_pin.sym} -140 80 1 0 {name=p7 sig_type=std_logic lab=vx
}
C {lab_pin.sym} 60 180 3 0 {name=p8 sig_type=std_logic lab=vx
}
C {opin.sym} -140 320 1 0 {name=p9 lab=vout
}
C {opin.sym} 100 350 1 0 {name=p10 lab=vout
}
C {ipin.sym} -210 130 0 0 {name=p11 lab=vin}
C {ipin.sym} -210 260 0 0 {name=p12 lab=vip
}
C {sg13g2_pr/rppd.sym} -80 -10 0 0 {name=R1
w=0.5e-6
l=0.5e-6
model=rppd
body=sub!
spiceprefix=X
b=0
 m=1
  mm_ok=1
value=30k
}
C {iopin.sym} -80 -80 3 0 {name=p13 lab=vdd}
C {lab_pin.sym} -80 50 3 0 {name=p14 sig_type=std_logic lab=vb
}
C {lab_pin.sym} 220 140 0 0 {name=p15 sig_type=std_logic lab=vb
}
C {iopin.sym} 280 340 1 0 {name=p16 lab=vss
}
C {iopin.sym} -80 130 2 1 {name=p17 lab=vss
}
C {iopin.sym} -80 260 2 1 {name=p18 lab=vss
}
