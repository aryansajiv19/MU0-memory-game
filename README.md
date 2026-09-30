# MU0 Memory Game

A four-digit memory game written in assembly for MU0, a minimal 16-bit processor, using the development board's keypad, 7-segment displays, LEDs and buzzer.

## Overview

MU0 is the eight-instruction accumulator machine used at the University of Manchester to teach processor design. The game displays a pseudo-random four-digit number, hides it after a fixed interval, and asks the player to type it back. A correct answer lights the green LED with a high tone; a wrong one lights the red LED with a low tone.

It was written for a first-year computer engineering module, and the interest is in the constraints: no multiply or divide, no immediate operands, no indirect addressing and no subroutine calls.

## Highlights

- **Arithmetic without division.** Digits are extracted by repeated subtraction of 1000, 100 and 10, using `JGE` to detect underflow.
- **Memory-mapped I/O by polling.** Keypad, displays, LEDs and buzzer are driven through fixed addresses, with keypresses debounced by waiting for release.
- **Deliberate unrolling.** The key decoder is duplicated per digit rather than generalised, because the instruction set cannot parameterise a routine.

## How it works

1. The seed advances by a fixed step to produce the next number.
2. The number is split into four digits and written to the displays.
3. Nested countdown loops hold the display, then it is cleared.
4. Four keypresses are read and decoded, each echoed to its display.
5. Digits are compared from most significant to least; the first mismatch branches to the failure path.

## Architecture

MU0 has a 4-bit opcode and a 12-bit address, which gives eight instructions and 4K words of memory.

| Instruction | Operation |
|---|---|
| `LDA S` / `STA S` | Load or store the accumulator |
| `ADD S` / `SUB S` | Add or subtract a memory operand |
| `JMP S` | Unconditional jump |
| `JGE S` / `JNE S` | Jump if the accumulator is non-negative / non-zero |
| `STP` | Halt |

Code starts at `&000` and data at `&450`. Because there are no immediate operands, every constant (the digits 0 to 9, powers of ten, keypad masks, LED patterns and buzzer tones) is stored in a data table. Peripherals sit at the top of memory: keypad `&FF2`, displays `&FF5` to `&FF8`, buzzer `&FFD` and LEDs `&FFF`.

## Engineering decisions

**Repeated subtraction instead of division.** With no divide instruction, each digit is the number of times a power of ten can be subtracted before the result turns negative. For a four-digit number this costs at most 30 loop iterations, which is negligible next to the display delay.

**Unrolling over self-modifying code.** A single decode routine would need to write to a different display and variable for each digit, which MU0 can only achieve by rewriting its own instructions at run time. That saves memory but is hard to follow and debug. Unrolling the decoder four times costs code size and keeps each digit's control flow linear and readable.

**Waiting for key release.** The keypad is polled until it reads non-zero, the value is latched, and the program then waits for zero again. Without the release wait, one press would be read as several digits at the processor's speed.

**One-hot key decoding.** Each key sets one bit (key 0 is `&0001`, key 9 is `&0200`), so decoding is a comparison against ten masks. This avoids shifts, which MU0 does not have.

## Getting started

Assemble `memory_game.s` with the MU0 assembler in the university laboratory toolchain, load it onto an MU0 board or the simulator, and run from `&000`.

`memory_game.s.kmd` is the assembled listing, mapping each source line to its address and machine code, followed by the symbol table.

## Future work

- **Bound the generator.** The seed only grows, so from round 36 it exceeds 9,999 and the leading digit exceeds 9; from round 147 it passes `&7FFF` and reads as negative. Subtracting 10,000 after each update, when the result stays non-negative, keeps it in range.
- **Seed from player timing.** The fixed seed replays the same sequence after each reset; counting polling loops before the first keypress would vary it.
- **Reject simultaneous keypresses.** A value with more than one bit set currently decodes as 0.
