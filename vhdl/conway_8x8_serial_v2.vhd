--- 8x8 conway's game of life using serial input and output to save on IO
--- V2 uses system_memory_v2 instead of separate system memory and input shift register

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https: //mozilla.org/MPL/2.0/.

library ieee;
use ieee.std_logic_1164.all;

entity CONWAY_8X8_SERIAL_V2 is
    generic (
        data_size : positive := 64
    );
    port (
        DATA_IN   : in  std_logic; -- Serial data in
        MODE      : in  std_logic_vector(1 downto 0); -- System Mode (00 = load, 01 = run, 10 = output, 11 = Undefined)
        RESET     : in  std_logic; -- Asynchronous system reset -- TODO: Should this be logic low?
        CLK       : in  std_logic; -- System clock; -- TODO: Separate clocks for shift regs so they can run faster?
        DATA_OUT  : out std_logic; -- Serial data out.
        DIN_LED   : out std_logic; -- Data input LED for debugging
        CLK_LED   : out std_logic; -- Clock LED for debugging
        DOUT_LED  : out std_logic; -- Data output LED for debugging
        MODE_LEDS : out std_logic_vector(1 downto 0)  -- Mode LEDs for debugging
    );
end entity CONWAY_8X8_SERIAL_V2;

architecture RTL of CONWAY_8X8_SERIAL_V2 is

    component PARALLEL_TO_SERIAL is
        generic (
            data_size : positive
        );
        port (
            DATA_IN  : in  std_logic_vector((data_size - 1) downto 0);
            LOAD_EN  : in  std_logic;
            SHIFT_EN : in  std_logic;
            CLK      : in  std_logic;
            RST      : in  std_logic;
            DATA     : out std_logic
        );
    end component PARALLEL_TO_SERIAL;

    component SYSTEM_MEMORY_V2 is
        generic (
            data_size : positive
        );
        port (
            GRID_IN   : in  std_logic_vector((data_size - 1) downto 0);
            SERIAL_IN : in  std_logic;
            LOAD_MODE : in  std_logic;
            RUN_MODE  : in  std_logic;
            CLK       : in  std_logic;
            RESET     : in  std_logic;
            DATA_OUT  : out std_logic_vector((data_size - 1) downto 0)
        );
    end component SYSTEM_MEMORY_V2;

    component CELL_GRID is
        port (
            INPUT_STATE : in  std_logic_vector(63 downto 0);
            NEXT_STATE  : out std_logic_vector(63 downto 0)
        );
    end component CELL_GRID;

    component DECODER is
        port (
            VAL_IN : in  std_logic_vector(1 downto 0);
            VAL_00 : out std_logic;
            VAL_01 : out std_logic;
            VAL_10 : out std_logic;
            VAL_11 : out std_logic
        );
    end component DECODER;

    signal LOAD_MODE   : std_logic;
    signal RUN_MODE    : std_logic;
    signal OUTPUT_MODE : std_logic;
    signal STOP_MODE   : std_logic;
    signal LOAD_OR_RUN : std_logic;
    signal MEM_OUT     : std_logic_vector(63 downto 0);
    signal NEXT_STATE  : std_logic_vector(63 downto 0);
    signal SERIAL_OUT  : std_logic;

begin

    -- Decoder for the modes. Only one mode will ever be set at a time
    mode_decode : DECODER
        port map (
            VAL_IN => MODE,
            VAL_00 => STOP_MODE,
            VAL_01 => LOAD_MODE,
            VAL_10 => RUN_MODE,
            VAL_11 => OUTPUT_MODE
        );

    LOAD_OR_RUN <= LOAD_MODE OR RUN_MODE;

    -- The system memory that we hold everything in between cycles
    memory : SYSTEM_MEMORY_V2
        generic map (
            data_size => data_size
        )
        port map (
            GRID_IN   => NEXT_STATE,
            SERIAL_IN => DATA_IN,
            LOAD_MODE => LOAD_MODE,
            RUN_MODE  => RUN_MODE,
            CLK       => CLK,
            RESET     => RESET,
            DATA_OUT  => MEM_OUT
        );

    -- Core calculation system
    grid : CELL_GRID
        port map (
            INPUT_STATE => MEM_OUT,
            NEXT_STATE  => NEXT_STATE
        );

    -- Parallel to serial shift registerr
    output_shift_reg : PARALLEL_TO_SERIAL
        generic map (
            data_size => data_size
        )
        port map (
            DATA_IN  => NEXT_STATE,
            LOAD_EN  => LOAD_OR_RUN,
            SHIFT_EN => OUTPUT_MODE,
            CLK      => CLK,
            RST      => RESET,
            DATA     => SERIAL_OUT
        );

    -- Main output
    DATA_OUT <= SERIAL_OUT;

    -- LED Routing
    DIN_LED   <= DATA_IN;
    CLK_LED   <= CLK;
    DOUT_LED  <= SERIAL_OUT;
    MODE_LEDS <= MODE;

end architecture RTL;