--- A shift register that supports both parallel and serial inputs and outputs
library ieee;
use ieee.std_logic_1164.all;


entity SHIFT_REGISTER is
    generic (depth : positive := 64); -- Depth of the shift register
    port (
        SERIAL_IN    : in std_logic; -- Serial data input
        PARALLEL_IN  : in std_logic_vector((depth-1) downto 0); -- Parallel data input

        -- If both SHIFT_ENABLE and LOAD_ENABLE are set, LOAD_ENABLE
        -- will take precedence.
        SHIFT_ENABLE : in std_logic; -- Enable data input/output serially
        LOAD_ENABLE  : in std_logic; -- Enable data parallel data input
        RESET        : in std_logic; -- Reset everything to zero
        CLK          : in std_logic; -- Clock

        SERIAL_OUT   : out std_logic; -- Serial data output
        PARALLEL_OUT : out std_logic_vector((depth-1) downto 0)  -- Parallel data output
    );
end entity SHIFT_REGISTER;

architecture RTL of SHIFT_REGISTER is

    signal SR_TMP : std_logic_vector((depth - 1) downto 0); -- Shift register internal memory
begin

    -- Got this from here: https://vhdlwhiz.com/shift-register/
    process(CLK, RESET)
    begin
        if RESET = '1' then
            SR_TMP <= (others => '0');
            SERIAL_OUT <= '0';
        elsif rising_edge(CLK) then

            if LOAD_ENABLE = '1' then
                SR_TMP <= PARALLEL_IN;
            elsif SHIFT_ENABLE = '1' then
                -- Shift out the uppermost value
                SERIAL_OUT <= SR_TMP(SR_TMP'high);

                -- Take a slice of the bottom 63 elements, and concatenate it with the new value
                -- This means we have shifted everying up one bit, and shifted in the new value at the bottom
                -- & is concatenate in VHDL
                SR_TMP <= SR_TMP((SR_TMP'high - 1) downto SR_TMP'low) & SERIAL_IN;
            end if;
        end if;
    end process;

    -- Parallel data output
    PARALLEL_OUT <= SR_TMP;
end RTL;

