--- 8x8 conway's game of life using serial input and output to save on IO

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https: //mozilla.org/MPL/2.0/.

library ieee;
use ieee.std_logic_1164.all;



entity CONWAY_8x8_SERIAL is
    generic (data_size : positive := 64);
    port (
        DATA_IN : in std_logic; -- Serial data in
        MODE    : in std_logic_vector(1 downto 0); -- System Mode (00 = load, 01 = run, 10 = output, 11 = Disable Clock via AND gate)
        RESET   : in std_logic; -- Asynchronous system reset -- TODO: Should this be logic low?
        CLK     : in std_logic; -- System clock; -- TODO: Separate clocks for shift regs so they can run faster?

        DATA_OUT : out std_logic -- Serial data out.

    );
end entity CONWAY_8x8_SERIAL;

architecture RTL of CONWAY_8x8_SERIAL is

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

    component SERIAL_TO_PARALLEL is
        generic (data_size : positive);
        port (
        DATA_IN : in std_logic; -- Serial input
        EN      : in std_logic; -- Enables shifting data in
        CLK     : in std_logic; -- Clock in
        RST     : in std_logic; -- Asynchronous Reset

        DATA    : out std_logic_vector((data_size - 1) downto 0) -- Parallel data out.
        );
    end component SERIAL_TO_PARALLEL;

    component SYSTEM_MEMORY is
        generic (data_size : positive);
        port (
            INITIAL_IN   : in std_logic_vector((data_size-1) downto 0); -- Input from external word for initialization
            GRID_IN      : in std_logic_vector((data_size-1) downto 0); -- Input from the grid calculator
            WRITE_ENABLE : in std_logic; -- Enable writing to memory
            LOAD_RUN     : in std_logic; -- Whether we are in load mode or run mode. Used to select which input to read from
            CLK          : in std_logic; -- System clock
            RESET        : in std_logic; -- Asynchronous reset.

            MEM_OUT     : out std_logic_vector((data_size-1) downto 0) -- Memory output

        );
    end component SYSTEM_MEMORY;

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

    signal DATA_IN_PARALLEL : std_logic_vector(63 downto 0); -- Input data in parallel form
    signal MEM_OUT          : std_logic_vector(63 downto 0); -- Output from memory
    signal NEXT_STATE       : std_logic_vector(63 downto 0); -- Output from cell calculation grid

    --signal GATED_CLOCK : std_logic;


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

    -- Shift register for converting input from serial to parallel
    input_shift_reg : SERIAL_TO_PARALLEL
        generic map (data_size => data_size)
        port map (
            DATA_IN => DATA_IN,
            EN => LOAD_MODE,
            CLK => CLK,
            RST => RESET,
            DATA => DATA_IN_PARALLEL
        );

    -- The system memory that we hold everything in between cycles
    memory : SYSTEM_MEMORY
        generic map (data_size => data_size)
        port map (
            INITIAL_IN => DATA_IN_PARALLEL,
            GRID_IN => NEXT_STATE,
            WRITE_ENABLE => LOAD_OR_RUN,
            LOAD_RUN => RUN_MODE,
            CLK => CLK,
            RESET => RESET,
            MEM_OUT => MEM_OUT
        );

    -- Core calculation system
    grid : CELL_GRID
        port map (
            INPUT_STATE => MEM_OUT,
            NEXT_STATE => NEXT_STATE
        );

    -- Parallel to serial shift registerr
    output_shift_reg : PARALLEL_TO_SERIAL
        generic map (data_size => data_size)
        port map (
            DATA_IN => NEXT_STATE,
            LOAD_EN => LOAD_OR_RUN,
            SHIFT_EN => OUTPUT_MODE,
            CLK => CLK,
            RST => RESET,

            DATA => DATA_OUT
        );


end architecture;