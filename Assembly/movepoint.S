.org $8000
start:
    LDX #$FF
    TXS

    LDA #2
    STA $01
    LDA #0
    STA $00
    LDY #0
    LDA #0
    JSR clear_monitor_page_loop
    LDX #0
    LDA #0
    JSR clear_zero_page_loop

    LDX #10  ; starting x point of the dot
    STX $00
    LDX #10  ; starting y point of the dot
    STX $01
    LDX #6   ; color of the dot
    STX $02
    LDX #1   ; bitmask for up arrow
    STX $04
    LDX #2   ; bitmask for down arrow
    STX $05
    LDX #4   ; bitmask for left arrow
    STX $06
    LDX #8   ; bitmask for right arrow
    STX $07

    JMP main

clear_zero_page_loop:
    STA $00,X
    INX
    BNE clear_zero_page_loop
    RTS

clear_monitor_page_loop:
    STA ($00),Y
    INY
    BNE clear_monitor_page_loop
    RTS

main:
    LDA $4000
    CMP $04
    BEQ move_up
    LDA $4000
    CMP $05
    BEQ move_down
    LDA $4000
    CMP $06
    BEQ move_left
    LDA $4000
    CMP $07
    BEQ move_right

set_cell:
    JSR parse_xy
    LDA $02
    STA $0200,X
    JMP main

parse_xy:
    CLC
    LDA #0
    ADC $01
    ASL A
    ASL A
    ASL A
    ASL A
    ADC $00
    STA $03
    LDX $03
    RTS

move_up:
    JSR clear_old_cell
    SEC
    LDA $01
    SBC #1
    JSR clear_leftmost_halfbyte
    STA $01
    CLC
    JMP set_cell

move_down:
    JSR clear_old_cell
    LDA $01
    ADC #1
    JSR clear_leftmost_halfbyte
    STA $01
    CLC
    JMP set_cell

move_left:
    JSR clear_old_cell
    SEC
    LDA $00
    SBC #1
    JSR clear_leftmost_halfbyte
    STA $00
    CLC
    JMP set_cell

move_right:
    JSR clear_old_cell
    LDA $00
    ADC #1
    JSR clear_leftmost_halfbyte
    STA $00
    CLC
    JMP set_cell

clear_leftmost_halfbyte:
    ASL A
    ASL A
    ASL A
    ASL A
    LSR A
    LSR A
    LSR A
    LSR A
    RTS

clear_old_cell:
    JSR parse_xy
    LDA #0
    STA $0200,X
    RTS

.goto $FFFA
.dw start
.dw start
.dw start