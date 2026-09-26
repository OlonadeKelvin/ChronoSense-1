v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 1020 -200 1040 -200 {lab=pad}
N 970 -180 1040 -180 {lab=vref}
N 1650 130 1680 130 {lab=vg}
N 1650 240 1680 240 {lab=vg}
N 1370 -510 1370 -490 {lab=vg}
N 1720 270 1720 310 {lab=ctn}
N 1350 -660 1350 -630 {lab=ctn}
N 1350 -570 1350 -400 {lab=vss}
N 1740 -140 1740 -120 {lab=ctn}
N 960 50 1040 50 {lab=ctn}
N 1660 -90 1700 -90 {lab=sch}
N 1000 -330 1040 -330 {lab=sch}
N 1340 -310 1420 -310 {lab=schb}
N 1720 -290 1770 -290 {lab=out}
N 1340 -330 1400 -330 {lab=vdd}
N 1340 -290 1370 -290 {lab=vss}
N 1720 -310 1840 -310 {lab=vdd}
N 1720 -270 1880 -270 {lab=vss}
N 1720 70 1720 100 {lab=vdd}
N 1720 190 1720 210 {lab=vdd}
N 1720 130 1750 130 {lab=vdd}
N 1750 70 1750 130 {lab=vdd}
N 1730 70 1750 70 {lab=vdd}
N 1720 240 1750 240 {lab=vdd}
N 1750 190 1750 240 {lab=vdd}
N 1720 190 1750 190 {lab=vdd}
N 1740 -40 1740 10 {lab=vss}
N 1740 -90 1780 -90 {lab=vss}
N 1780 -90 1780 -40 {lab=vss}
N 1740 -40 1780 -40 {lab=vss}
N 1740 -60 1740 -40 {lab=vss}
N 1370 90 1400 90 {lab=vss}
N 1370 10 1370 90 {lab=vss}
N 1330 90 1370 90 {lab=vss}
N 1340 -180 1370 -180 {lab=vss}
N 1880 -270 1880 10 {lab=vss}
N 1740 10 1880 10 {lab=vss}
N 1370 10 1740 10 {lab=vss}
N 1350 -400 1370 -400 {lab=vss}
N 1370 -430 1370 -400 {lab=vss}
N 1730 60 1730 70 {lab=vdd}
N 1720 70 1730 70 {lab=vdd}
N 1750 70 1770 70 {lab=vdd}
N 1750 130 1750 190 {lab=vdd}
N 1400 60 1730 60 {lab=vdd}
N 1330 50 1400 50 {lab=vdd}
N 1840 -310 1840 40 {lab=vdd}
N 1750 40 1840 40 {lab=vdd}
N 1750 40 1750 70 {lab=vdd}
N 1020 -230 1020 -200 {lab=pad}
N 970 -200 1020 -200 {lab=pad}
N 1340 -160 1430 -160 {lab=vg}
N 1330 70 1410 70 {lab=sch}
N 1340 -200 1400 -200 {lab=vdd}
N 1400 50 1400 60 {lab=vdd}
N 1720 160 1720 170 {lab=pad}
N 1370 -400 1370 -290 {lab=vss}
N 1370 -290 1370 -180 {lab=vss}
N 1400 -330 1400 -200 {lab=vdd}
N 1400 -200 1400 50 {lab=vdd}
N 1370 -180 1370 10 {lab=vss}
C {ota.sym} 1190 -180 0 0 {name=x1}
C {inv.sym} 1190 -310 0 0 {name=x3}
C {inv.sym} 1570 -290 0 0 {name=x4}
C {sg13g2_pr/sg13_lv_nmos.sym} 1720 -90 0 0 {name=XMRST
l=0.35u
w=10u
ng=1
m=1
mm_ok=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_pmos.sym} 1700 130 0 0 {name=XMPASS
l=1u
w=5u
ng=1
m=20
mm_ok=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_pmos.sym} 1700 240 0 0 {name=XMMIR
l=1u
w=5u
ng=1
m=30
mm_ok=1
model=sg13_lv_pmos
spiceprefix=X
}
C {/foss/pdks/ihp-sg13g2/libs.tech/xschem/sg13g2_pr/cap_cmim.sym} 1370 -460 0 0 {name=Cc
model=cap_cmim
 w=18.25u
 l=18.25u
 m=4
  mm_ok=1
 spiceprefix=X}
C {/foss/pdks/ihp-sg13g2/libs.tech/xschem/sg13g2_pr/cap_cmim.sym} 1350 -600 0 0 {name=CT
model=cap_cmim
 w=25u
 l=25u
 m=16
  mm_ok=1
 spiceprefix=X}
C {iopin.sym} 970 -200 2 0 {name=p1 lab=pad}
C {ipin.sym} 970 -180 0 0 {name=p4 lab=vref
}
C {opin.sym} 1770 -290 0 0 {name=p5 lab=out
}
C {lab_pin.sym} 1650 130 0 0 {name=p7 sig_type=std_logic lab=vg}
C {lab_pin.sym} 1650 240 0 0 {name=p8 sig_type=std_logic lab=vg}
C {lab_pin.sym} 1370 -510 1 0 {name=p9 sig_type=std_logic lab=vg}
C {lab_pin.sym} 1720 310 3 0 {name=p11 sig_type=std_logic lab=ctn
}
C {lab_pin.sym} 1350 -660 1 0 {name=p12 sig_type=std_logic lab=ctn
}
C {lab_pin.sym} 1740 -140 1 0 {name=p14 sig_type=std_logic lab=ctn
}
C {lab_pin.sym} 960 50 2 1 {name=p15 sig_type=std_logic lab=ctn
}
C {lab_pin.sym} 1410 70 2 0 {name=p16 sig_type=std_logic lab=sch
}
C {lab_pin.sym} 1660 -90 0 0 {name=p17 sig_type=std_logic lab=sch
}
C {lab_pin.sym} 1000 -330 0 0 {name=p18 sig_type=std_logic lab=sch
}
C {lab_pin.sym} 1420 -310 1 0 {name=p19 sig_type=std_logic lab=schb}
C {iopin.sym} 1400 90 0 0 {name=p24 lab=vss}
C {iopin.sym} 1770 70 0 0 {name=p25 lab=vdd}
C {schmitt.sym} 1180 70 0 0 {name=x2}
C {lab_pin.sym} 1720 170 0 0 {name=p2 sig_type=std_logic lab=pad
}
C {lab_pin.sym} 1020 -230 0 0 {name=p3 sig_type=std_logic lab=pad
}
C {lab_pin.sym} 1430 -160 0 1 {name=p10 sig_type=std_logic lab=vg}
