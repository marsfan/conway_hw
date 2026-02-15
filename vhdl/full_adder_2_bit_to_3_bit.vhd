--- Adder that takes in 2x2bit values and returns 3 bit sum

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

library ieee;
use ieee.std_logic_1164.all;

entity FULL_ADDER_2_BIT_TO_3_BIT is
    port (
        A   : in  std_logic_vector(1 downto 0);
        B   : in  std_logic_vector(1 downto 0);
        SUM : out std_logic_vector(2 downto 0)
    );
end entity FULL_ADDER_2_BIT_TO_3_BIT;

architecture RTL of FULL_ADDER_2_BIT_TO_3_BIT is

    -- Intermediate carry
    signal CARRY_INT : std_logic;

    component FULL_ADDER is
        port (
            A     : in  std_logic;
            B     : in  std_logic;
            C_IN  : in  std_logic;
            SUM   : out std_logic;
            CARRY : out std_logic
        );
    end component FULL_ADDER;

begin

    first_adder : FULL_ADDER
        port map (
            A     => A(0),
            B     => B(0),
            C_IN  => '0',
            SUM   => SUM(0),
            CARRY => CARRY_INT
        );

    second_adder : FULL_ADDER
        port map (
            A     => A(1),
            B     => B(1),
            C_IN  => CARRY_INT,
            SUM   => SUM(1),
            CARRY => SUM(2)
        );

end architecture RTL;