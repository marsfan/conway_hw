--- 8x8 conway's game of life using serial input and output to save on IO

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

library ieee;
use ieee.std_logic_1164.all;

entity CONWAY_8X8_SERIAL is
    generic (
        data_size : positive := 64
    );
    port (
        DATA_IN  : in  std_logic; -- Serial data in
        MODE     : in  std_logic_vector(1 downto 0); -- System Mode (00 = load, 01 = run, 10 = output, 11 = Undefined)
        RESET    : in  std_logic; -- Asynchronous system reset -- TODO: Should this be logic low?
        CLK      : in  std_logic; -- System clock; -- TODO: Separate clocks for shift regs so they can run faster?
        DATA_OUT : out std_logic -- Serial data out.
    );
end entity CONWAY_8X8_SERIAL;

architecture RTL of CONWAY_8X8_SERIAL is

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

    component SERIAL_TO_PARALLEL is
        generic (
            data_size : positive
        );
        port (
            DATA_IN : in  std_logic;
            EN      : in  std_logic;
            CLK     : in  std_logic;
            RST     : in  std_logic;
            DATA    : out std_logic_vector((data_size - 1) downto 0)
        );
    end component SERIAL_TO_PARALLEL;

    component SYSTEM_MEMORY is
        generic (
            data_size : positive
        );
        port (
            INITIAL_IN   : in  std_logic_vector((data_size - 1) downto 0);
            GRID_IN      : in  std_logic_vector((data_size - 1) downto 0);
            WRITE_ENABLE : in  std_logic;
            LOAD_RUN     : in  std_logic;
            CLK          : in  std_logic;
            RESET        : in  std_logic;
            MEM_OUT      : out std_logic_vector((data_size - 1) downto 0)
        );
    end component SYSTEM_MEMORY;

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
            VAL_00 : out std_logic; -- High when input is 00
            VAL_01 : out std_logic; -- High when input is 01
            VAL_10 : out std_logic; -- High when input is 10
            VAL_11 : out std_logic  -- High when input is 11
        );
    end component DECODER;

    signal LOAD_MODE        : std_logic; -- High when mode = 00
    signal RUN_MODE         : std_logic; -- High when mode = 01
    signal OUTPUT_MODE      : std_logic; -- High when mode = 10
    signal STOP_MODE        : std_logic; -- High when mode = 11
    signal LOAD_OR_RUN      : std_logic; -- High when mode = 00 or 01
    signal DATA_IN_PARALLEL : std_logic_vector(data_size - 1 downto 0); -- Input data in parallel form
    signal MEM_OUT          : std_logic_vector(data_size - 1 downto 0); -- Output from memory
    signal NEXT_STATE       : std_logic_vector(data_size - 1 downto 0); -- Output from cell calculation grid

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

    -- Shift register for converting input from serial to parallel
    input_shift_reg : SERIAL_TO_PARALLEL
        generic map (
            data_size => data_size
        )
        port map (
            DATA_IN => DATA_IN,
            EN      => LOAD_MODE,
            CLK     => CLK,
            RST     => RESET,
            DATA    => DATA_IN_PARALLEL
        );

    -- The system memory that we hold everything in between cycles
    memory : SYSTEM_MEMORY
        generic map (
            data_size => data_size
        )
        port map (
            INITIAL_IN   => DATA_IN_PARALLEL,
            GRID_IN      => NEXT_STATE,
            WRITE_ENABLE => LOAD_OR_RUN,
            LOAD_RUN     => RUN_MODE,
            CLK          => CLK,
            RESET        => RESET,
            MEM_OUT      => MEM_OUT
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
            DATA     => DATA_OUT
        );

end architecture RTL;