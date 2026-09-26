v {xschem version=3.4.8RC file_version=1.3
* Copyright 2023 IHP PDK Authors
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     https://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.

}
G {}
K {}
V {}
S {}
F {}
E {}
N 480 -630 510 -630 {lab=in}
N 480 -630 480 -550 {lab=in}
N 480 -550 510 -550 {lab=in}
N 550 -600 550 -580 {lab=out}
N 550 -670 550 -660 {lab=vdd}
N 550 -670 570 -670 {lab=vdd}
N 550 -520 550 -500 {lab=vss}
N 570 -500 580 -500 {lab=vss}
N 550 -550 570 -550 {lab=vss}
N 570 -550 570 -500 {lab=vss}
N 550 -500 570 -500 {lab=vss}
N 550 -630 570 -630 {lab=vdd}
N 570 -670 570 -630 {lab=vdd}
N 570 -670 580 -670 {lab=vdd}
C {sg13g2_pr/sg13_lv_pmos.sym} 530 -630 0 0 {name=M1
l=0.35u
w=2u
ng=1
m=1
mm_ok=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_nmos.sym} 530 -550 0 0 {name=M2
l=0.35u
w=1u
ng=1
m=1
mm_ok=1
model=sg13_lv_nmos
spiceprefix=X
}
C {ipin.sym} 480 -590 0 0 {name=p1 lab=in}
C {opin.sym} 550 -590 0 0 {name=p2 lab=out
}
C {iopin.sym} 580 -670 0 0 {name=p3 lab=vdd}
C {iopin.sym} 580 -500 0 0 {name=p4 lab=vss
}
