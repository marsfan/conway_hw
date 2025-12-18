-- A half adder
library ieee;
use ieee.std_logic_1164.all;

entity HALF_ADDER is
    port (
        A     : in std_logic;
        B     : in std_logic;
        SUM   : out std_logic;
        CARRY : out std_logic
    );
end entity HALF_ADDER;

architecture RTL of HALF_ADDER is
begin
        SUM <= A XOR B;
        CARRY <= A AND B;
end RTL;