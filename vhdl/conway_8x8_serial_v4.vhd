--- 8x8 conway's game of life using serial input and output to save on IO
--- V4 uses system_memory_v4 instead of separate system memory, input shift register, and output shift register
--- So one MUST ALWAYS read out a multiple of 64 bits at a time.

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https: //mozilla.org/MPL/2.0/.

library ieee;
use ieee.std_logic_1164.all;

entity CONWAY_8X8_SERIAL_V4 is
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
end entity CONWAY_8X8_SERIAL_V4;

architecture RTL of CONWAY_8X8_SERIAL_V4 is

    component SYSTEM_MEMORY_V4 is
        generic (
            data_size : positive
        );
        port (
            GRID_IN        : in  std_logic_vector((data_size - 1) downto 0);
            SERIAL_IN      : in  std_logic;
            LOAD_MODE      : in  std_logic;
            RUN_MODE       : in  std_logic;
            OUTPUT_MODE    : in  std_logic;
            CLK            : in  std_logic;
            RESET          : in  std_logic;
            SYSTEM_MEM_OUT : out std_logic_vector((data_size - 1) downto 0);
            SERIAL_OUT     : out std_logic
        );
    end component SYSTEM_MEMORY_V4;

    component CELL_GRID is
        generic (
            grid_width  : positive;
            grid_height : positive
        );
        port (
            INPUT_STATE : in  std_logic_vector((grid_width * grid_height - 1) downto 0);
            NEXT_STATE  : out std_logic_vector((grid_width * grid_height - 1) downto 0)
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

    signal LOAD_MODE   : std_logic; -- High when mode = 00
    signal RUN_MODE    : std_logic; -- High when mode = 01
    signal OUTPUT_MODE : std_logic; -- High when mode = 10
    signal STOP_MODE   : std_logic; -- High when mode = 11
    signal LOAD_OR_RUN : std_logic; -- High when mode = 00 or 01
    signal MEM_OUT     : std_logic_vector(data_size - 1 downto 0); -- Output from memory
    signal NEXT_STATE  : std_logic_vector(data_size - 1 downto 0); -- Output from cell calculation grid
    signal SERIAL_OUT  : std_logic; -- Intermediate data output signal

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
    memory : SYSTEM_MEMORY_V4
        generic map (
            data_size => data_size
        )
        port map (
            GRID_IN        => NEXT_STATE,
            SERIAL_IN      => DATA_IN,
            LOAD_MODE      => LOAD_MODE,
            RUN_MODE       => RUN_MODE,
            OUTPUT_MODE    => OUTPUT_MODE,
            CLK            => CLK,
            RESET          => RESET,
            SYSTEM_MEM_OUT => MEM_OUT,
            SERIAL_OUT     => SERIAL_OUT
        );

    -- Core calculation system
    grid : CELL_GRID
        generic map (
            grid_width  => 8,
            grid_height => 8
        )
        port map (
            INPUT_STATE => MEM_OUT,
            NEXT_STATE  => NEXT_STATE
        );

    -- Main output
    DATA_OUT <= SERIAL_OUT;

    -- LED Routing
    DIN_LED   <= DATA_IN;
    CLK_LED   <= CLK;
    DOUT_LED  <= SERIAL_OUT;
    MODE_LEDS <= MODE;

end architecture RTL;