--- 8x8 conway's game of life using serial input and output to save on IO
--- V2 uses system_memory_v3 instead of separate system memory, input shift register, and output shift register


-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https: //mozilla.org/MPL/2.0/.
library ieee;
use ieee.std_logic_1164.all;



entity CONWAY_8x8_SERIAL_V3 is
    generic (data_size : positive := 64);
    port (
        DATA_IN : in std_logic; -- Serial data in
        MODE    : in std_logic_vector(1 downto 0); -- System Mode (00 = load, 01 = run, 10 = output, 11 = Disable Clock via AND gate)
        RESET   : in std_logic; -- Asynchronous system reset -- TODO: Should this be logic low?
        CLK     : in std_logic; -- System clock; -- TODO: Separate clocks for shift regs so they can run faster?

        DATA_OUT : out std_logic; -- Serial data out.

        -- LED outputs for debugging purposes
        DIN_LED : out std_logic;
        CLK_LED : out std_logic;
        DOUT_LED : out std_logic;
        MODE_LEDS : out std_logic_vector(1 downto 0)

    );
end entity CONWAY_8x8_SERIAL_V3;

architecture RTL of CONWAY_8x8_SERIAL_V3 is

    component PARALLEL_TO_SERIAL is
        generic (data_size : positive);
        port (
        DATA_IN  : in std_logic_vector((data_size - 1) downto 0); -- Parallel input
        LOAD_EN  : in std_logic; -- Enables loading data in in parallel
        SHIFT_EN : in std_logic; -- Enables shifting data out serially
        CLK      : in std_logic; -- Clock in
        RST      : in std_logic; -- Asynchronous Reset

        DATA     : out std_logic  -- Serial data out.
        );
    end component PARALLEL_TO_SERIAL;



    component SYSTEM_MEMORY_V3 is
        generic (data_size : positive);
        port (

            GRID_IN        : in std_logic_vector((data_size-1) downto 0); -- Input from the grid calculator
            SERIAL_IN      : in std_logic; -- Serial input from external interface

            -- RUN_MODE has priority.
            -- Then LOAD_MODE
            -- Then OUTPUT_MODE
            LOAD_MODE      : in std_logic; -- Indicates system is in load mode (i.e. load from serial)
            RUN_MODE       : in std_logic; -- Indcates system is in run mode (i.e. load from grid in)
            OUTPUT_MODE    : in std_logic; -- Indicates system is in output mode (i.e. shift out over serial)


            CLK            : in std_logic; -- System clock
            RESET          : in std_logic; -- Asynchronous reset.

            SYSTEM_MEM_OUT : out std_logic_vector((data_size-1) downto 0); -- Memory output for the system to use
            SERIAL_OUT     : out std_logic -- Serial system output



        );
    end component SYSTEM_MEMORY_V3;

    component CELL_GRID is
        port (
            INPUT_STATE : in std_logic_vector(63 downto 0);
            NEXT_STATE  : out std_logic_vector(63 downto 0)
        );
    end component CELL_GRID;

    component DECODER is
        port (
            VAL_IN : in std_logic_vector(1 downto 0);

            VAL_00 : out std_logic; -- High when input is 00
            VAL_01 : out std_logic; -- High when input is 01
            VAL_10 : out std_logic; -- High when input is 10
            VAL_11 : out std_logic  -- High when input is 11
        );
    end component DECODER;

    signal LOAD_MODE   : std_logic; -- High when mode = 00
    signal RUN_MODE    : std_logic; -- High when mode = 01
    signal OUTPUT_MODE : std_logic; -- High when mode = 10
    signal STOP_MODE   : std_logic; -- High when mode = 11
    signal LOAD_OR_RUN : std_logic; -- High when mode = 00 or 01

    signal MEM_OUT          : std_logic_vector(63 downto 0); -- Output from memory
    signal NEXT_STATE       : std_logic_vector(63 downto 0); -- Output from cell calculation grid

    --signal GATED_CLOCK : std_logic;
    signal SERIAL_OUT : std_logic; -- Intermediate data output signal


begin

    -- Decoder for the modes. Only one mode will ever be set at a time
    mode_decode : DECODER port map (
        VAL_IN => MODE,
        VAL_00 => STOP_MODE,
        VAL_01 => LOAD_MODE,
        VAL_10 => RUN_MODE,
        VAL_11 => OUTPUT_MODE
    );
    LOAD_OR_RUN <= LOAD_MODE OR RUN_MODE;

    --GATED_CLOCK <= CLK AND (NOT STOP_MODE);


    -- The system memory that we hold everything in between cycles
    memory : SYSTEM_MEMORY_V3
        generic map (data_size => data_size)
        port map (
            GRID_IN => NEXT_STATE,
            SERIAL_IN => DATA_IN,
            LOAD_MODE => LOAD_MODE,
            RUN_MODE => RUN_MODE,
            OUTPUT_MODE => OUTPUT_MODE,
            CLK => CLK,
            RESET => RESET,
            SYSTEM_MEM_OUT => MEM_OUT,
            SERIAL_OUT => SERIAL_OUT
        );

    -- Core calculation system
    grid : CELL_GRID
        port map (
            INPUT_STATE => MEM_OUT,
            NEXT_STATE => NEXT_STATE
        );

    -- Main output
    DATA_OUT <= SERIAL_OUT;

    -- LED Routing
    DIN_LED <= DATA_IN;
    CLK_LED <= CLK;
    DOUT_LED <= SERIAL_OUT;
    MODE_LEDS <= MODE;


end architecture;