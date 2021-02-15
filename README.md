# Connect 4

Category: Digital IC Lab
Tags: on going

# Document For Lab project Connect 4

---

## File organization

- **game_board_tb.v**

    top layer module, where all submodules are connected.

    this is a test bench allowing better observability into the operation.

    - **check state machine.v**

        **state machine coding is not optimized**

        This module search the whole game board.

        Outputs whether victory condition is matched at current position

        - **check_grid.v**

            check if victory condition is matched in a 4$\times$4 grid.

            - **check_slice.v**

                base module in check grid. provide function to check 4 consecutive cell (2 bits per cell)

    - **edit state machine.v**

        **state machine coding is not optimized**

        This state machine provides the function to place "chip" in a game board. 

    - **game board.v**

        A chuck of ram.

    - **show board.v**

        **state machine coding is not optimized**

        State machine that displays the content in the game board.

    - **top STM.v (can be rewrite to enable concurrent operation)**

        **state machine coding is not optimized**

        State machine that schedules the operation of sub- state machines

---

## Project back ground.

There are 2 players holding Green and Orange chips respectively.

Chips can only be placed on another chip or at the bottom. 

Victory is reached if there are 4 consecutive chips of the same color (horizontally, vertically, diagonally).

This game machine should be able to display the game board using Led Array

---

## Operation

- There are three tasks: display, edit, checking.
- Top STM schedules these tasks sequentially

    ![Connect%204%202e90e794c9d349ddbbbf783273691465/Untitled.png](Connect%204%202e90e794c9d349ddbbbf783273691465/Untitled.png)

    Top STM state transition

- Edit state machine counts the number of chips already in a column

    if there is no place, the chance for this player is forfeited

- check grid

    The data stored in a cell is coded in (G:2'b01  O:2'b10).

    The whole check grid is a 8-bits wide, 4 deep shift register.

    The first entry(row) is checked, all four columns are checked, 2 diagonal lines are checked.