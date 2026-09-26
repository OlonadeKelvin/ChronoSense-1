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
N -220 290 -220 310 {lab=outi}
N -220 -20 -220 -10 {lab=outi}
N 50 -90 50 -50 {lab=y}
N 50 -160 50 -150 {lab=vss}
N -20 -120 10 -120 {lab=outi}
N 60 150 60 180 {lab=vdd}
N 60 40 60 70 {lab=x}
N -10 100 20 100 {lab=outi}
N 120 -20 140 -20 {lab=outi}
N -220 -150 -190 -150 {lab=vss}
N -190 -200 -190 -150 {lab=vss}
N -220 -200 -190 -200 {lab=vss}
N -220 -210 -220 -200 {lab=vss}
N -220 -50 -150 -50 {lab=vdd}
N -220 150 -180 150 {lab=vdd}
N -180 110 -180 150 {lab=vdd}
N -220 110 -180 110 {lab=vdd}
N -220 100 -220 110 {lab=vdd}
N -220 260 -150 260 {lab=vss}
N 50 -120 80 -120 {lab=vss}
N 80 -160 80 -120 {lab=vss}
N 50 -160 80 -160 {lab=vss}
N 50 -170 50 -160 {lab=vss}
N 60 100 90 100 {lab=vdd}
N 90 100 90 150 {lab=vdd}
N 60 150 90 150 {lab=vdd}
N 60 130 60 150 {lab=vdd}
N 440 -0 460 -0 {lab=out}
N 440 -20 460 -20 {lab=vdd}
N 440 20 460 20 {lab=vss}
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
C {iopin.sym} -150 -50 0 0 {name=p1 lab=vdd
}
C {iopin.sym} -220 100 3 0 {name=p2 lab=vdd


}
C {lab_pin.sym} -220 200 0 0 {name=p3 sig_type=std_logic lab=y}
C {iopin.sym} -220 -210 1 1 {name=p4 lab=vss
}
C {lab_pin.sym} -220 -100 0 0 {name=p5 sig_type=std_logic lab=x}
C {ipin.sym} -300 50 0 0 {name=p6 lab=in
}
C {opin.sym} -220 -10 1 0 {name=p7 lab=outi
}
C {opin.sym} -220 310 1 0 {name=p8 lab=outi
}
C {iopin.sym} 50 -170 1 1 {name=p9 lab=vss
}
C {lab_pin.sym} 50 -50 0 0 {name=p10 sig_type=std_logic lab=y}
C {opin.sym} -20 -120 2 0 {name=p11 lab=outi
}
C {iopin.sym} 60 180 1 0 {name=p12 lab=vdd


}
C {lab_pin.sym} 60 40 0 0 {name=p13 sig_type=std_logic lab=x}
C {opin.sym} -10 100 2 0 {name=p14 lab=outi
}
C {inv.sym} 290 0 0 0 {name=x1}
C {opin.sym} 120 -20 2 0 {name=p15 lab=outi
}
C {iopin.sym} -150 260 0 0 {name=p16 lab=vss

}
C {iopin.sym} 460 -20 0 0 {name=p17 lab=vdd
}
C {iopin.sym} 460 20 0 0 {name=p18 lab=vss

}
C {opin.sym} 460 0 2 1 {name=p19 lab=out
}
