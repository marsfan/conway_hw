-- Parallel to serial shift register
library ieee;
use ieee.std_logic_1164.all;

entity PARALLEL_TO_SERIAL is
    generic (data_size : positive := 64);
    port (
        DATA_IN  : in std_logic_vector((data_size - 1) downto 0); -- Parallel input
        LOAD_EN  : in std_logic; -- Enables loading data in in parallel
        SHIFT_EN : in std_logic; -- Enables shifting data out serially
        CLK      : in std_logic; -- Clock in
        RST      : in std_logic; -- Asynchronous Reset

        DATA     : out std_logic  -- Serial data out.
    );
end entity PARALLEL_TO_SERIAL;

architecture RTL of PARALLEL_TO_SERIAL is

    signal SR_TMP : std_logic_vector((data_size - 1) downto 0) := (OTHERS => '0');

begin

    shift_register_process : process(CLK, RST)
    begin
        if RST = '1' then
            DATA <= '0';
            SR_TMP <= (others => '0');
        elsif rising_edge(CLK) then
            if LOAD_EN = '1' then
                SR_TMP <= DATA_IN;
            elsif SHIFT_EN = '1' then
    
                -- Push out the lowest value
                DATA <= SR_TMP(SR_TMP'low);
                
                -- Concatenate a zero with the upper 63 elements. 
                -- This means we have shifted everything down one bit, and shifted
                -- in a zero at the top. 
                -- & is concatenate in VHDL
                SR_TMP <= '0' & SR_TMP(SR_TMP'high downto (SR_TMP'low + 1));

             end if;
        end if;
    end process;
    
end architecture RTL;