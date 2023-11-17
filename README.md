# IoT-Assembly Course Assignments

## Assignment 4

I'm pleased to share my work on Assignment 4, which focused on ARM assembly programming for GPIO control in IoT devices.

**Key Achievements**:
- Implemented direct hardware register access for LED control and button state reading, without using C functions.
- Created a binary counter using LEDs, advancing the counter with a 2-second interval and implementing a reset functionality.
- Skillfully utilized timer interrupts for counter operations instead of standard delay functions, demonstrating advanced ARM assembly language proficiency.
- Successfully debugged and optimized assembly code for real-time interaction and efficient operation in IoT applications.

**Available Resources**:
- [Assignment 4](./A4/Assignment4.pdf)
- [Task 1 Code](./A4/task1.s)
- [Task 2 Code](./A4/task2.s)

## Assignment 3

I'm excited to present my work on Assignment 3, which was centered around ARM assembly programming for basic input/output operations in IoT devices.

**Key Achievements**:
1. **Calculating Average**: Developed a program to calculate the average value of eight numbers stored in the .data section. This involved mastering PC relative addressing and showcasing the result in the terminal.
2. **LED Control with Pushbuttons**: Implemented a setup where an LED connected to GP0 is controlled by two pushbuttons connected to GP1 and GP2. The program turns on the LED when the GP1 button is pressed and turns it off when the GP2 button is pressed.
3. **Blinking LED Speed Control**: Enhanced the previous task by adding two more pushbuttons connected to GP3 and GP4. Programmed the LED to blink with variable speeds controlled by these buttons - increasing speed with GP3 and decreasing with GP4. The speed adjustments were set at 100ms increments/decrements, with limits to ensure visible blinking rates.

**Skills Demonstrated**:
- Proficiency in accessing data with PC relative addressing in ARM assembly.
- Creation of simple subroutines for modular and efficient code.
- Ability to interface and program GPIO for real-time input and output operations, crucial in IoT applications.

**Available Resources**:
- [Assignment 3](./A3/Assignment3.pdf)
- [Task 1 Code](./A3/task1.s)
- [Task 2 Code](./A3/task2.s)

# NOTE: 
To actually run this code, you would need to provide the necessary cmake files. We flashed this using a VM running Raspberry Pi OS.
