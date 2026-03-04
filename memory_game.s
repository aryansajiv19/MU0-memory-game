; 4-DIGIT MEMORY GAME FOR MU0
; Student: Aryan Sajiv, Student ID: 14308227
; Updated last by Aryan Sajiv on Nov 28th
; Game shows a random 4 digit number on display
; Player must type it back
; Green LED flashes if correct
; Red LED flashes if incorrect
; Buzzer beeps with different sounds for right and wrong answers

; Peripheral addresses
lights EQU &FFF
keys EQU &FF2
disp0 EQU &FF5
disp1 EQU &FF6
disp2 EQU &FF7
disp3 EQU &FF8
buzzer EQU &FFD

ORG &000

; Main game loop
MAIN
    ; Generate random number
    LDA seed
    ADD step
    STA seed
    STA work

    ; Get thousands digit
    LDA zero
    STA num3
G3
    LDA work
    SUB k1000
    JGE G3A
    JMP G2S
G3A
    STA work
    LDA num3
    ADD one
    STA num3
    JMP G3

    ; Get hundreds digit
G2S
    LDA zero
    STA num2
G2
    LDA work
    SUB k100
    JGE G2A
    JMP G1S
G2A
    STA work
    LDA num2
    ADD one
    STA num2
    JMP G2

    ; Get tens digit
G1S
    LDA zero
    STA num1
G1
    LDA work
    SUB k10
    JGE G1A
    JMP G0S
G1A
    STA work
    LDA num1
    ADD one
    STA num1
    JMP G1

    ; Get units digit
G0S
    LDA work
    STA num0

    ; Show number on display
    LDA num3
    STA disp3
    LDA num2
    STA disp2
    LDA num1
    STA disp1
    LDA num0
    STA disp0

    ; Wait so player can see number
    LDA outer
    STA cnt2
DOUT
    LDA wait
    STA tmr
DIN
    LDA tmr
    SUB one
    STA tmr
    JNE DIN
    LDA cnt2
    SUB one
    STA cnt2
    JNE DOUT

    ; Clear display
    LDA zero
    STA disp3
    STA disp2
    STA disp1
    STA disp0

    ; Read key 3
R3
    LDA keys
    JNE P3
    JMP R3
P3
    STA kval
W3
    LDA keys
    JNE W3
    JMP C3

    ; Read key 2
R2
    LDA keys
    JNE P2
    JMP R2
P2
    STA kval
W2
    LDA keys
    JNE W2
    JMP C2

    ; Read key 1
R1
    LDA keys
    JNE P1
    JMP R1
P1
    STA kval
W1
    LDA keys
    JNE W1
    JMP C1

    ; Read key 0
R0
    LDA keys
    JNE P0
    JMP R0
P0
    STA kval
W0
    LDA keys
    JNE W0
    JMP C0

    ; Compare input with target
CMP
    LDA num3
    SUB in3
    JNE BAD
    LDA num2
    SUB in2
    JNE BAD
    LDA num1
    SUB in1
    JNE BAD
    LDA num0
    SUB in0
    JNE BAD

    ; Correct - flash green, good beep
WIN
    LDA green
    STA lights
    LDA beepok
    STA buzzer
    LDA fout
    STA cnt2
WON
    LDA flash
    STA tmr
WO1
    LDA tmr
    SUB one
    STA tmr
    JNE WO1
    LDA cnt2
    SUB one
    STA cnt2
    JNE WON
    LDA zero
    STA lights
    JMP MAIN

    ; Wrong - flash red, error beep
BAD
    LDA red
    STA lights
    LDA beepno
    STA buzzer
    LDA fout
    STA cnt2
LOS
    LDA flash
    STA tmr
LO1
    LDA tmr
    SUB one
    STA tmr
    JNE LO1
    LDA cnt2
    SUB one
    STA cnt2
    JNE LOS
    LDA zero
    STA lights
    JMP MAIN

; Convert key 3 bitmask to digit
C3
    LDA kval
    SUB b0
    JNE C3A
    LDA zero
    STA in3
    STA disp3
    JMP R2
C3A
    LDA kval
    SUB b1
    JNE C3B
    LDA one
    STA in3
    STA disp3
    JMP R2
C3B
    LDA kval
    SUB b2
    JNE C3C
    LDA two
    STA in3
    STA disp3
    JMP R2
C3C
    LDA kval
    SUB b3
    JNE C3D
    LDA three
    STA in3
    STA disp3
    JMP R2
C3D
    LDA kval
    SUB b4
    JNE C3E
    LDA four
    STA in3
    STA disp3
    JMP R2
C3E
    LDA kval
    SUB b5
    JNE C3F
    LDA five
    STA in3
    STA disp3
    JMP R2
C3F
    LDA kval
    SUB b6
    JNE C3G
    LDA six
    STA in3
    STA disp3
    JMP R2
C3G
    LDA kval
    SUB b7
    JNE C3H
    LDA seven
    STA in3
    STA disp3
    JMP R2
C3H
    LDA kval
    SUB b8
    JNE C3I
    LDA eight
    STA in3
    STA disp3
    JMP R2
C3I
    LDA kval
    SUB b9
    JNE C3X
    LDA nine
    STA in3
    STA disp3
    JMP R2
C3X
    LDA zero
    STA in3
    STA disp3
    JMP R2

; Convert key 2 bitmask to digit
C2
    LDA kval
    SUB b0
    JNE C2A
    LDA zero
    STA in2
    STA disp2
    JMP R1
C2A
    LDA kval
    SUB b1
    JNE C2B
    LDA one
    STA in2
    STA disp2
    JMP R1
C2B
    LDA kval
    SUB b2
    JNE C2C
    LDA two
    STA in2
    STA disp2
    JMP R1
C2C
    LDA kval
    SUB b3
    JNE C2D
    LDA three
    STA in2
    STA disp2
    JMP R1
C2D
    LDA kval
    SUB b4
    JNE C2E
    LDA four
    STA in2
    STA disp2
    JMP R1
C2E
    LDA kval
    SUB b5
    JNE C2F
    LDA five
    STA in2
    STA disp2
    JMP R1
C2F
    LDA kval
    SUB b6
    JNE C2G
    LDA six
    STA in2
    STA disp2
    JMP R1
C2G
    LDA kval
    SUB b7
    JNE C2H
    LDA seven
    STA in2
    STA disp2
    JMP R1
C2H
    LDA kval
    SUB b8
    JNE C2I
    LDA eight
    STA in2
    STA disp2
    JMP R1
C2I
    LDA kval
    SUB b9
    JNE C2X
    LDA nine
    STA in2
    STA disp2
    JMP R1
C2X
    LDA zero
    STA in2
    STA disp2
    JMP R1

; Convert key 1 bitmask to digit
C1
    LDA kval
    SUB b0
    JNE C1A
    LDA zero
    STA in1
    STA disp1
    JMP R0
C1A
    LDA kval
    SUB b1
    JNE C1B
    LDA one
    STA in1
    STA disp1
    JMP R0
C1B
    LDA kval
    SUB b2
    JNE C1C
    LDA two
    STA in1
    STA disp1
    JMP R0
C1C
    LDA kval
    SUB b3
    JNE C1D
    LDA three
    STA in1
    STA disp1
    JMP R0
C1D
    LDA kval
    SUB b4
    JNE C1E
    LDA four
    STA in1
    STA disp1
    JMP R0
C1E
    LDA kval
    SUB b5
    JNE C1F
    LDA five
    STA in1
    STA disp1
    JMP R0
C1F
    LDA kval
    SUB b6
    JNE C1G
    LDA six
    STA in1
    STA disp1
    JMP R0
C1G
    LDA kval
    SUB b7
    JNE C1H
    LDA seven
    STA in1
    STA disp1
    JMP R0
C1H
    LDA kval
    SUB b8
    JNE C1I
    LDA eight
    STA in1
    STA disp1
    JMP R0
C1I
    LDA kval
    SUB b9
    JNE C1X
    LDA nine
    STA in1
    STA disp1
    JMP R0
C1X
    LDA zero
    STA in1
    STA disp1
    JMP R0

; Convert key 0 bitmask to digit
C0
    LDA kval
    SUB b0
    JNE C0A
    LDA zero
    STA in0
    STA disp0
    JMP CMP
C0A
    LDA kval
    SUB b1
    JNE C0B
    LDA one
    STA in0
    STA disp0
    JMP CMP
C0B
    LDA kval
    SUB b2
    JNE C0C
    LDA two
    STA in0
    STA disp0
    JMP CMP
C0C
    LDA kval
    SUB b3
    JNE C0D
    LDA three
    STA in0
    STA disp0
    JMP CMP
C0D
    LDA kval
    SUB b4
    JNE C0E
    LDA four
    STA in0
    STA disp0
    JMP CMP
C0E
    LDA kval
    SUB b5
    JNE C0F
    LDA five
    STA in0
    STA disp0
    JMP CMP
C0F
    LDA kval
    SUB b6
    JNE C0G
    LDA six
    STA in0
    STA disp0
    JMP CMP
C0G
    LDA kval
    SUB b7
    JNE C0H
    LDA seven
    STA in0
    STA disp0
    JMP CMP
C0H
    LDA kval
    SUB b8
    JNE C0I
    LDA eight
    STA in0
    STA disp0
    JMP CMP
C0I
    LDA kval
    SUB b9
    JNE C0X
    LDA nine
    STA in0
    STA disp0
    JMP CMP
C0X
    LDA zero
    STA in0
    STA disp0
    JMP CMP

; Data section
ORG &450

; Target digits
num3 DEFW &0000
num2 DEFW &0000
num1 DEFW &0000
num0 DEFW &0000

; Player input
in3 DEFW &0000
in2 DEFW &0000
in1 DEFW &0000
in0 DEFW &0000

; Variables
work DEFW &0000
tmr DEFW &0000
cnt2 DEFW &0000
kval DEFW &0000
seed DEFW &0ABC

; Constants 0-9
zero DEFW &0000
one DEFW &0001
two DEFW &0002
three DEFW &0003
four DEFW &0004
five DEFW &0005
six DEFW &0006
seven DEFW &0007
eight DEFW &0008
nine DEFW &0009

; Other constants
step DEFW &00CD
k1000 DEFW &03E8
k100 DEFW &0064
k10 DEFW &000A

; Keypad bitmasks
b0 DEFW &0001
b1 DEFW &0002
b2 DEFW &0004
b3 DEFW &0008
b4 DEFW &0010
b5 DEFW &0020
b6 DEFW &0040
b7 DEFW &0080
b8 DEFW &0100
b9 DEFW &0200

; LED bits
green DEFW &0100
red DEFW &0400

; Timing
wait DEFW &FFFF
flash DEFW &FFFF
outer DEFW &0004
fout DEFW &0004

; Buzzer sounds
beepok DEFW &8550
beepno DEFW &8340


