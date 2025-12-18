--- Shift register that shifts data in serially and outputs parallel
library ieee;
use ieee.std_logic_1164.all;

entity SERIAL_TO_PARALLEL is
    generic (data_size : positive := 64);
    port (
        DATA_IN : in std_logic; -- Serial input
        EN      : in std_logic; -- Enables shifting data in
        CLK     : in std_logic; -- Clock in
        RST     : in std_logic; -- Asynchronous Reset

        DATA    : out std_logic_vector((data_size - 1) downto 0) -- Parallel data out.
    );
end entity SERIAL_TO_PARALLEL;

architecture RTL of SERIAL_TO_PARALLEL is

    signal SR_TMP : std_logic_vector((data_size - 1) downto 0); -- Intermediate shift register value
    

    begin

        -- Got this from here: https://vhdlwhiz.com/shift-register/
        shift_register_process : process(CLK, RST)
        begin
            if RST = '1' then
                SR_TMP <= (others => '0');
                DATA <= (others => '0');
            elsif rising_edge(CLK) and (EN = '1') then

                -- Shift everything up by 1 bit. This will expand out into
                -- parallel logic!
                for i in SR_TMP'high downto (SR_TMP'low + 1) loop
                    SR_TMP(i) <= SR_TMP(i - 1);
                end loop;

                SR_TMP(SR_TMP'low) <= DATA_IN;
                DATA <= SR_TMP;
            end if;
        end process;
        


end architecture RTL;