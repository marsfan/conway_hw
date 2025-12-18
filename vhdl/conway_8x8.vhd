--- 8X8 conway's game of life implementation
library ieee;
use ieee.std_logic_1164.all;

entity CONWAY_8x8 is
    port (
        INITIAL_STATE : in std_logic_vector(63 downto 0); -- Input state to load system with
        CLK           : in std_logic; -- System Clock
        CLK_EN        : in std_logic; -- Gate for enabling clock to system
        LOAD_RUN      : in std_logic; -- Whether to load memory from initial state, or start running (i.e. load from previous state)

        CURRENT_STATE : out std_logic_vector(63 downto 0); -- Output for displaying the state currently in memory
        NEXT_STATE     : out std_logic_vector(63 downto 0) -- Output for displaying the next state to put into memory
    );
end CONWAY_8x8;

architecture RTL of CONWAY_8x8 is

    component CELL_GRID is
        port (
            INPUT_STATE : in std_logic_vector(63 downto 0);
            NEXT_STATE  : out std_logic_vector(63 downto 0)
        );
    end component CELL_GRID;

    component D_FLIP_FLOP is
        generic (width : positive);
        port (
            D     : in std_logic_vector((width - 1) downto 0);
            CLK   : in std_logic;
            RESET : in std_logic;
            Q     : out std_logic_vector((width - 1) downto 0)
        );
    end component D_FLIP_FLOP;

    signal GATED_CLK : std_logic;
    signal MEM_IN    : std_logic_vector(63 downto 0);
    signal MEM_OUT   : std_logic_vector(63 downto 0);
    signal GRID_IN   : std_logic_vector(63 downto 0);
    signal GRID_OUT  : std_logic_vector(63 downto 0);

begin

    GATED_CLK <= CLK AND CLK_EN;

    MEM_IN <= INITIAL_STATE when LOAD_RUN = '0' else GRID_OUT;

    memory : D_FLIP_FLOP
        generic map(width => 64)
        port map(
            D => MEM_IN,
            CLK => GATED_CLK,
            RESET => '0',
            Q => MEM_OUT
        );

    GRID_IN <= INITIAL_STATE when LOAD_RUN = '0' else MEM_OUT;

    grid : CELL_GRID port map (
        INPUT_STATE => GRID_IN,
        NEXT_STATE => GRID_OUT
    );

    CURRENT_STATE <= GRID_IN;
    NEXT_STATE <= GRID_OUT;


end architecture RTL;