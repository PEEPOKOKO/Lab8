pinSeg EQU P1 
pinPos EQU P3 

ORG 0000H
    JMP START

ORG 0003H
    JMP PLUS_TWO_ISR

ORG 0013H
    JMP PLUS_ONE_ISR

ORG 0100H
START:
    MOV SP, #3FH
    SETB IT0
    SETB IT1
    SETB EX0
    SETB EX1
    SETB EA
    MOV R7, #00H

LOOP:
    MOV DPH, #00H
    MOV DPL, R7
    CALL Display4Digit
    JMP LOOP

PLUS_TWO_ISR:
    PUSH Acc
    MOV A, R7
    ADD A, #02H
    DA A
    MOV R7, A
    JMP CHECK_OVER

PLUS_ONE_ISR:
    PUSH Acc
    MOV A, R7
    ADD A, #01H
    DA A
    MOV R7, A

CHECK_OVER:
    ANL A, #0F0H
    CJNE A, #0A0H, EXIT_ISR
    MOV R7, #00H

EXIT_ISR:
    MOV R6, #100
    DJNZ R6, $
    POP Acc
    RETI

Display4Digit:
    MOV B, #1
    MOV A, DPL
Display2Digit:
    PUSH Acc
    SWAP A
    CALL Display1Digit
    POP Acc
Display1Digit:
    PUSH Acc
    PUSH DPH
    PUSH DPL
    MOV DPTR, #SegmentTable
    ANL A, #0FH
    MOVC A, @A+DPTR
    CPL A
    MOV pinSeg, A
    MOV DPTR, #SegmentPosition
    MOV A, B
    MOVC A, @A+DPTR
    ORL pinPos, A
    CLR A
    DJNZ Acc, $
    ANL pinPos, #0FH
    POP DPL
    POP DPH
    POP Acc
    DEC B
    RET

SegmentPosition:
    DB 80H, 40H, 20H, 10H

SegmentTable:
    DB 3FH, 06H, 5BH, 4FH, 66H, 6DH, 7DH, 07H, 7FH, 6FH

END