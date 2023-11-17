@ Assembler program for Task 2
.thumb_func
.global main

.EQU LED_GREEN, 0
.EQU BUTTON_ON, 1
.EQU BUTTON_OFF, 2
.EQU GPIO_OUT, 1
.EQU sleep_time, 1500

main:
    MOV R0, #LED_GREEN
    BL gpio_init
    MOV R0, #LED_GREEN
    MOV R1, #GPIO_OUT
    BL link_gpio_set_dir
    MOV R0, #BUTTON_ON
    BL link_gpio_pull_up
    MOV R0, #BUTTON_OFF
    BL link_gpio_pull_up
    B input_check

input_check:
    MOV R0, #BUTTON_ON
    BL link_gpio_get
    CMP R0, #0
    BEQ turn_on

    MOV R0, #BUTTON_OFF
    BL link_gpio_get
    CMP R0, #0
    BEQ turn_off

    B input_check

turn_on:
    MOV R0, #LED_GREEN
    MOV R1, #1
    BL link_gpio_put
    B input_check

turn_off:
    MOV R0, #LED_GREEN
    MOV R1, #0
    BL link_gpio_put
    B input_check
