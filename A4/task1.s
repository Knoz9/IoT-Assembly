#include "hardware/regs/addressmap.h"
#include "hardware/regs/sio.h"
#include "hardware/regs/io_bank0.h"
#include "hardware/regs/pads_bank0.h"

.EQU LED, 0
.EQU BUTTON_ON, 1
.EQU BUTTON_OFF, 2

.thumb_func
.global main    @ Provide program starting address
.align 4        @ necessary alignment

main:
    @ Init each of the three pins and set them to output
    MOV R0, #LED
    BL gpioinit
    MOV R0, #BUTTON_ON
    BL gpioinit
    MOV R0, #BUTTON_OFF
    BL gpioinit

loop:
    MOV R0, #BUTTON_ON
    BL gpio_read
    CMP R0, #1
    BEQ turn_on

    MOV R0, #BUTTON_OFF
    BL gpio_read
    CMP R0, #1
    BEQ turn_off

    B loop

turn_off:
    MOV R0, #LED
    BL gpio_off
    B loop

turn_on:
    MOV R0, #LED
    BL gpio_on
    B loop

@ Initialize the GPIO to SIO. r0 = pin to init.
gpioinit:
    @ Initialize the GPIO
    MOV R3, #1
    LSL R3, R0                @ shift over to pin position
    LDR R2, gpiobase          @ address we want
    STR R3, [R2, #SIO_GPIO_OE_SET_OFFSET]
    STR R3, [R2, #SIO_GPIO_OUT_CLR_OFFSET]

    @ Enable input and output for the pin
    LDR R2, padsbank0
    LSL R3, R0, #2            @ pin * 4 for register address
    ADD R2, R3                @ Actual set of registers for pin
    MOV R1, #PADS_BANK0_GPIO0_IE_BITS
    LDR R4, setoffset
    ORR R2, R4
    STR R1, [R2, #PADS_BANK0_GPIO0_OFFSET] @ Set the function number to SIO.
    LSL R0, #3
    LDR R2, iobank0
    ADD R2, R0
    MOV R1, #IO_BANK0_GPIO3_CTRL_FUNCSEL_VALUE_SIO_3
    STR R1, [R2, #IO_BANK0_GPIO0_CTRL_OFFSET]
    BX LR

@ Turn on a GPIO pin.
gpio_on:
    MOV R3, #1
    LSL R3, R0                @ shift over to pin position
    LDR R2, gpiobase          @ address we want
    STR R3, [R2, #SIO_GPIO_OUT_SET_OFFSET]
    BX LR

@ Turn off a GPIO pin.
gpio_off:
    MOV R3, #1
    LSL R3, R0                @ shift over to pin position
    LDR R2, gpiobase          @ address we want
    STR R3, [R2, #SIO_GPIO_OUT_CLR_OFFSET]
    BX LR

@ Reads the button input and returns it. Uses pull_down.
gpio_read:
    MOV R3, #1
    LSL R3, R0                @ shift over to pin position
    LDR R2, gpiobase          @ address we want
    LDR R1, [R2, #SIO_GPIO_IN_OFFSET]
    AND R3, R1, R3
    LSR R3, R3, R0
    MOV R0, R3
    BX LR

gpiobase:
    .align 4                  @ necessary alignment
    .word SIO_BASE            @ base of the GPIO registers

iobank0:
    .align 4                  @ necessary alignment
    .word IO_BANK0_BASE       @ base of io config registers

padsbank0:
    .align 4                  @ necessary alignment
    .word PADS_BANK0_BASE

setoffset:
    .align 4                  @ necessary alignment
    .word REG_ALIAS_SET_BITS  @ each GPIO has 8 bytes of registers