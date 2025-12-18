--- Grid of cell calculators for the entire system

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https: //mozilla.org/MPL/2.0/.
library ieee;
use ieee.std_logic_1164.all;

entity CELL_GRID is
    port (
        INPUT_STATE : in std_logic_vector(63 downto 0);
        NEXT_STATE  : out std_logic_vector(63 downto 0)
    );
end CELL_GRID;


architecture RTL of CELL_GRID is

    component SINGLE_CELL is
        port (
            -- Current value of the cell
            ME    : in std_logic;

            -- Current states of neighboring cells
            N     : in std_logic;
            NE    : in std_logic;
            E     : in std_logic;
            SE    : in std_logic;
            S     : in std_logic;
            SW    : in std_logic;
            W     : in std_logic;
            NW    : in std_logic;

            -- New value of the cell
            IS_ALIVE : out std_logic
        );
    end component SINGLE_CELL;

begin

    -- NOTE: Start of cell grid here
    cell_0_0 : SINGLE_CELL port map(
        ME => INPUT_STATE(0),
        N => '0',
        NE => '0',
        E => INPUT_STATE(8),
        SE => INPUT_STATE(9),
        S => INPUT_STATE(1),
        SW => '0',
        W => '0',
        NW => '0',
        IS_ALIVE => NEXT_STATE(0)
    );

    cell_0_1 : SINGLE_CELL port map(
        ME => INPUT_STATE(1),
        N => INPUT_STATE(0),
        NE => INPUT_STATE(8),
        E => INPUT_STATE(9),
        SE => INPUT_STATE(10),
        S => INPUT_STATE(2),
        SW => '0',
        W => '0',
        NW => '0',
        IS_ALIVE => NEXT_STATE(1)
    );

    cell_0_2 : SINGLE_CELL port map(
        ME => INPUT_STATE(2),
        N => INPUT_STATE(1),
        NE => INPUT_STATE(9),
        E => INPUT_STATE(10),
        SE => INPUT_STATE(11),
        S => INPUT_STATE(3),
        SW => '0',
        W => '0',
        NW => '0',
        IS_ALIVE => NEXT_STATE(2)
    );

    cell_0_3 : SINGLE_CELL port map(
        ME => INPUT_STATE(3),
        N => INPUT_STATE(2),
        NE => INPUT_STATE(10),
        E => INPUT_STATE(11),
        SE => INPUT_STATE(12),
        S => INPUT_STATE(4),
        SW => '0',
        W => '0',
        NW => '0',
        IS_ALIVE => NEXT_STATE(3)
    );

    cell_0_4 : SINGLE_CELL port map(
        ME => INPUT_STATE(4),
        N => INPUT_STATE(3),
        NE => INPUT_STATE(11),
        E => INPUT_STATE(12),
        SE => INPUT_STATE(13),
        S => INPUT_STATE(5),
        SW => '0',
        W => '0',
        NW => '0',
        IS_ALIVE => NEXT_STATE(4)
    );

    cell_0_5 : SINGLE_CELL port map(
        ME => INPUT_STATE(5),
        N => INPUT_STATE(4),
        NE => INPUT_STATE(12),
        E => INPUT_STATE(13),
        SE => INPUT_STATE(14),
        S => INPUT_STATE(6),
        SW => '0',
        W => '0',
        NW => '0',
        IS_ALIVE => NEXT_STATE(5)
    );

    cell_0_6 : SINGLE_CELL port map(
        ME => INPUT_STATE(6),
        N => INPUT_STATE(5),
        NE => INPUT_STATE(13),
        E => INPUT_STATE(14),
        SE => INPUT_STATE(15),
        S => INPUT_STATE(7),
        SW => '0',
        W => '0',
        NW => '0',
        IS_ALIVE => NEXT_STATE(6)
    );

    cell_0_7 : SINGLE_CELL port map(
        ME => INPUT_STATE(7),
        N => INPUT_STATE(6),
        NE => INPUT_STATE(14),
        E => INPUT_STATE(15),
        SE => '0',
        S => '0',
        SW => '0',
        W => '0',
        NW => '0',
        IS_ALIVE => NEXT_STATE(7)
    );

    cell_1_0 : SINGLE_CELL port map(
        ME => INPUT_STATE(8),
        N => '0',
        NE => '0',
        E => INPUT_STATE(16),
        SE => INPUT_STATE(17),
        S => INPUT_STATE(9),
        SW => INPUT_STATE(1),
        W => INPUT_STATE(0),
        NW => '0',
        IS_ALIVE => NEXT_STATE(8)
    );

    cell_1_1 : SINGLE_CELL port map(
        ME => INPUT_STATE(9),
        N => INPUT_STATE(8),
        NE => INPUT_STATE(16),
        E => INPUT_STATE(17),
        SE => INPUT_STATE(18),
        S => INPUT_STATE(10),
        SW => INPUT_STATE(2),
        W => INPUT_STATE(1),
        NW => INPUT_STATE(0),
        IS_ALIVE => NEXT_STATE(9)
    );

    cell_1_2 : SINGLE_CELL port map(
        ME => INPUT_STATE(10),
        N => INPUT_STATE(9),
        NE => INPUT_STATE(17),
        E => INPUT_STATE(18),
        SE => INPUT_STATE(19),
        S => INPUT_STATE(11),
        SW => INPUT_STATE(3),
        W => INPUT_STATE(2),
        NW => INPUT_STATE(1),
        IS_ALIVE => NEXT_STATE(10)
    );

    cell_1_3 : SINGLE_CELL port map(
        ME => INPUT_STATE(11),
        N => INPUT_STATE(10),
        NE => INPUT_STATE(18),
        E => INPUT_STATE(19),
        SE => INPUT_STATE(20),
        S => INPUT_STATE(12),
        SW => INPUT_STATE(4),
        W => INPUT_STATE(3),
        NW => INPUT_STATE(2),
        IS_ALIVE => NEXT_STATE(11)
    );

    cell_1_4 : SINGLE_CELL port map(
        ME => INPUT_STATE(12),
        N => INPUT_STATE(11),
        NE => INPUT_STATE(19),
        E => INPUT_STATE(20),
        SE => INPUT_STATE(21),
        S => INPUT_STATE(13),
        SW => INPUT_STATE(5),
        W => INPUT_STATE(4),
        NW => INPUT_STATE(3),
        IS_ALIVE => NEXT_STATE(12)
    );

    cell_1_5 : SINGLE_CELL port map(
        ME => INPUT_STATE(13),
        N => INPUT_STATE(12),
        NE => INPUT_STATE(20),
        E => INPUT_STATE(21),
        SE => INPUT_STATE(22),
        S => INPUT_STATE(14),
        SW => INPUT_STATE(6),
        W => INPUT_STATE(5),
        NW => INPUT_STATE(4),
        IS_ALIVE => NEXT_STATE(13)
    );

    cell_1_6 : SINGLE_CELL port map(
        ME => INPUT_STATE(14),
        N => INPUT_STATE(13),
        NE => INPUT_STATE(21),
        E => INPUT_STATE(22),
        SE => INPUT_STATE(23),
        S => INPUT_STATE(15),
        SW => INPUT_STATE(7),
        W => INPUT_STATE(6),
        NW => INPUT_STATE(5),
        IS_ALIVE => NEXT_STATE(14)
    );

    cell_1_7 : SINGLE_CELL port map(
        ME => INPUT_STATE(15),
        N => INPUT_STATE(14),
        NE => INPUT_STATE(22),
        E => INPUT_STATE(23),
        SE => '0',
        S => '0',
        SW => '0',
        W => INPUT_STATE(7),
        NW => INPUT_STATE(6),
        IS_ALIVE => NEXT_STATE(15)
    );

    cell_2_0 : SINGLE_CELL port map(
        ME => INPUT_STATE(16),
        N => '0',
        NE => '0',
        E => INPUT_STATE(24),
        SE => INPUT_STATE(25),
        S => INPUT_STATE(17),
        SW => INPUT_STATE(9),
        W => INPUT_STATE(8),
        NW => '0',
        IS_ALIVE => NEXT_STATE(16)
    );

    cell_2_1 : SINGLE_CELL port map(
        ME => INPUT_STATE(17),
        N => INPUT_STATE(16),
        NE => INPUT_STATE(24),
        E => INPUT_STATE(25),
        SE => INPUT_STATE(26),
        S => INPUT_STATE(18),
        SW => INPUT_STATE(10),
        W => INPUT_STATE(9),
        NW => INPUT_STATE(8),
        IS_ALIVE => NEXT_STATE(17)
    );

    cell_2_2 : SINGLE_CELL port map(
        ME => INPUT_STATE(18),
        N => INPUT_STATE(17),
        NE => INPUT_STATE(25),
        E => INPUT_STATE(26),
        SE => INPUT_STATE(27),
        S => INPUT_STATE(19),
        SW => INPUT_STATE(11),
        W => INPUT_STATE(10),
        NW => INPUT_STATE(9),
        IS_ALIVE => NEXT_STATE(18)
    );

    cell_2_3 : SINGLE_CELL port map(
        ME => INPUT_STATE(19),
        N => INPUT_STATE(18),
        NE => INPUT_STATE(26),
        E => INPUT_STATE(27),
        SE => INPUT_STATE(28),
        S => INPUT_STATE(20),
        SW => INPUT_STATE(12),
        W => INPUT_STATE(11),
        NW => INPUT_STATE(10),
        IS_ALIVE => NEXT_STATE(19)
    );

    cell_2_4 : SINGLE_CELL port map(
        ME => INPUT_STATE(20),
        N => INPUT_STATE(19),
        NE => INPUT_STATE(27),
        E => INPUT_STATE(28),
        SE => INPUT_STATE(29),
        S => INPUT_STATE(21),
        SW => INPUT_STATE(13),
        W => INPUT_STATE(12),
        NW => INPUT_STATE(11),
        IS_ALIVE => NEXT_STATE(20)
    );

    cell_2_5 : SINGLE_CELL port map(
        ME => INPUT_STATE(21),
        N => INPUT_STATE(20),
        NE => INPUT_STATE(28),
        E => INPUT_STATE(29),
        SE => INPUT_STATE(30),
        S => INPUT_STATE(22),
        SW => INPUT_STATE(14),
        W => INPUT_STATE(13),
        NW => INPUT_STATE(12),
        IS_ALIVE => NEXT_STATE(21)
    );

    cell_2_6 : SINGLE_CELL port map(
        ME => INPUT_STATE(22),
        N => INPUT_STATE(21),
        NE => INPUT_STATE(29),
        E => INPUT_STATE(30),
        SE => INPUT_STATE(31),
        S => INPUT_STATE(23),
        SW => INPUT_STATE(15),
        W => INPUT_STATE(14),
        NW => INPUT_STATE(13),
        IS_ALIVE => NEXT_STATE(22)
    );

    cell_2_7 : SINGLE_CELL port map(
        ME => INPUT_STATE(23),
        N => INPUT_STATE(22),
        NE => INPUT_STATE(30),
        E => INPUT_STATE(31),
        SE => '0',
        S => '0',
        SW => '0',
        W => INPUT_STATE(15),
        NW => INPUT_STATE(14),
        IS_ALIVE => NEXT_STATE(23)
    );

    cell_3_0 : SINGLE_CELL port map(
        ME => INPUT_STATE(24),
        N => '0',
        NE => '0',
        E => INPUT_STATE(32),
        SE => INPUT_STATE(33),
        S => INPUT_STATE(25),
        SW => INPUT_STATE(17),
        W => INPUT_STATE(16),
        NW => '0',
        IS_ALIVE => NEXT_STATE(24)
    );

    cell_3_1 : SINGLE_CELL port map(
        ME => INPUT_STATE(25),
        N => INPUT_STATE(24),
        NE => INPUT_STATE(32),
        E => INPUT_STATE(33),
        SE => INPUT_STATE(34),
        S => INPUT_STATE(26),
        SW => INPUT_STATE(18),
        W => INPUT_STATE(17),
        NW => INPUT_STATE(16),
        IS_ALIVE => NEXT_STATE(25)
    );

    cell_3_2 : SINGLE_CELL port map(
        ME => INPUT_STATE(26),
        N => INPUT_STATE(25),
        NE => INPUT_STATE(33),
        E => INPUT_STATE(34),
        SE => INPUT_STATE(35),
        S => INPUT_STATE(27),
        SW => INPUT_STATE(19),
        W => INPUT_STATE(18),
        NW => INPUT_STATE(17),
        IS_ALIVE => NEXT_STATE(26)
    );

    cell_3_3 : SINGLE_CELL port map(
        ME => INPUT_STATE(27),
        N => INPUT_STATE(26),
        NE => INPUT_STATE(34),
        E => INPUT_STATE(35),
        SE => INPUT_STATE(36),
        S => INPUT_STATE(28),
        SW => INPUT_STATE(20),
        W => INPUT_STATE(19),
        NW => INPUT_STATE(18),
        IS_ALIVE => NEXT_STATE(27)
    );

    cell_3_4 : SINGLE_CELL port map(
        ME => INPUT_STATE(28),
        N => INPUT_STATE(27),
        NE => INPUT_STATE(35),
        E => INPUT_STATE(36),
        SE => INPUT_STATE(37),
        S => INPUT_STATE(29),
        SW => INPUT_STATE(21),
        W => INPUT_STATE(20),
        NW => INPUT_STATE(19),
        IS_ALIVE => NEXT_STATE(28)
    );

    cell_3_5 : SINGLE_CELL port map(
        ME => INPUT_STATE(29),
        N => INPUT_STATE(28),
        NE => INPUT_STATE(36),
        E => INPUT_STATE(37),
        SE => INPUT_STATE(38),
        S => INPUT_STATE(30),
        SW => INPUT_STATE(22),
        W => INPUT_STATE(21),
        NW => INPUT_STATE(20),
        IS_ALIVE => NEXT_STATE(29)
    );

    cell_3_6 : SINGLE_CELL port map(
        ME => INPUT_STATE(30),
        N => INPUT_STATE(29),
        NE => INPUT_STATE(37),
        E => INPUT_STATE(38),
        SE => INPUT_STATE(39),
        S => INPUT_STATE(31),
        SW => INPUT_STATE(23),
        W => INPUT_STATE(22),
        NW => INPUT_STATE(21),
        IS_ALIVE => NEXT_STATE(30)
    );

    cell_3_7 : SINGLE_CELL port map(
        ME => INPUT_STATE(31),
        N => INPUT_STATE(30),
        NE => INPUT_STATE(38),
        E => INPUT_STATE(39),
        SE => '0',
        S => '0',
        SW => '0',
        W => INPUT_STATE(23),
        NW => INPUT_STATE(22),
        IS_ALIVE => NEXT_STATE(31)
    );

    cell_4_0 : SINGLE_CELL port map(
        ME => INPUT_STATE(32),
        N => '0',
        NE => '0',
        E => INPUT_STATE(40),
        SE => INPUT_STATE(41),
        S => INPUT_STATE(33),
        SW => INPUT_STATE(25),
        W => INPUT_STATE(24),
        NW => '0',
        IS_ALIVE => NEXT_STATE(32)
    );

    cell_4_1 : SINGLE_CELL port map(
        ME => INPUT_STATE(33),
        N => INPUT_STATE(32),
        NE => INPUT_STATE(40),
        E => INPUT_STATE(41),
        SE => INPUT_STATE(42),
        S => INPUT_STATE(34),
        SW => INPUT_STATE(26),
        W => INPUT_STATE(25),
        NW => INPUT_STATE(24),
        IS_ALIVE => NEXT_STATE(33)
    );

    cell_4_2 : SINGLE_CELL port map(
        ME => INPUT_STATE(34),
        N => INPUT_STATE(33),
        NE => INPUT_STATE(41),
        E => INPUT_STATE(42),
        SE => INPUT_STATE(43),
        S => INPUT_STATE(35),
        SW => INPUT_STATE(27),
        W => INPUT_STATE(26),
        NW => INPUT_STATE(25),
        IS_ALIVE => NEXT_STATE(34)
    );

    cell_4_3 : SINGLE_CELL port map(
        ME => INPUT_STATE(35),
        N => INPUT_STATE(34),
        NE => INPUT_STATE(42),
        E => INPUT_STATE(43),
        SE => INPUT_STATE(44),
        S => INPUT_STATE(36),
        SW => INPUT_STATE(28),
        W => INPUT_STATE(27),
        NW => INPUT_STATE(26),
        IS_ALIVE => NEXT_STATE(35)
    );

    cell_4_4 : SINGLE_CELL port map(
        ME => INPUT_STATE(36),
        N => INPUT_STATE(35),
        NE => INPUT_STATE(43),
        E => INPUT_STATE(44),
        SE => INPUT_STATE(45),
        S => INPUT_STATE(37),
        SW => INPUT_STATE(29),
        W => INPUT_STATE(28),
        NW => INPUT_STATE(27),
        IS_ALIVE => NEXT_STATE(36)
    );

    cell_4_5 : SINGLE_CELL port map(
        ME => INPUT_STATE(37),
        N => INPUT_STATE(36),
        NE => INPUT_STATE(44),
        E => INPUT_STATE(45),
        SE => INPUT_STATE(46),
        S => INPUT_STATE(38),
        SW => INPUT_STATE(30),
        W => INPUT_STATE(29),
        NW => INPUT_STATE(28),
        IS_ALIVE => NEXT_STATE(37)
    );

    cell_4_6 : SINGLE_CELL port map(
        ME => INPUT_STATE(38),
        N => INPUT_STATE(37),
        NE => INPUT_STATE(45),
        E => INPUT_STATE(46),
        SE => INPUT_STATE(47),
        S => INPUT_STATE(39),
        SW => INPUT_STATE(31),
        W => INPUT_STATE(30),
        NW => INPUT_STATE(29),
        IS_ALIVE => NEXT_STATE(38)
    );

    cell_4_7 : SINGLE_CELL port map(
        ME => INPUT_STATE(39),
        N => INPUT_STATE(38),
        NE => INPUT_STATE(46),
        E => INPUT_STATE(47),
        SE => '0',
        S => '0',
        SW => '0',
        W => INPUT_STATE(31),
        NW => INPUT_STATE(30),
        IS_ALIVE => NEXT_STATE(39)
    );

    cell_5_0 : SINGLE_CELL port map(
        ME => INPUT_STATE(40),
        N => '0',
        NE => '0',
        E => INPUT_STATE(48),
        SE => INPUT_STATE(49),
        S => INPUT_STATE(41),
        SW => INPUT_STATE(33),
        W => INPUT_STATE(32),
        NW => '0',
        IS_ALIVE => NEXT_STATE(40)
    );

    cell_5_1 : SINGLE_CELL port map(
        ME => INPUT_STATE(41),
        N => INPUT_STATE(40),
        NE => INPUT_STATE(48),
        E => INPUT_STATE(49),
        SE => INPUT_STATE(50),
        S => INPUT_STATE(42),
        SW => INPUT_STATE(34),
        W => INPUT_STATE(33),
        NW => INPUT_STATE(32),
        IS_ALIVE => NEXT_STATE(41)
    );

    cell_5_2 : SINGLE_CELL port map(
        ME => INPUT_STATE(42),
        N => INPUT_STATE(41),
        NE => INPUT_STATE(49),
        E => INPUT_STATE(50),
        SE => INPUT_STATE(51),
        S => INPUT_STATE(43),
        SW => INPUT_STATE(35),
        W => INPUT_STATE(34),
        NW => INPUT_STATE(33),
        IS_ALIVE => NEXT_STATE(42)
    );

    cell_5_3 : SINGLE_CELL port map(
        ME => INPUT_STATE(43),
        N => INPUT_STATE(42),
        NE => INPUT_STATE(50),
        E => INPUT_STATE(51),
        SE => INPUT_STATE(52),
        S => INPUT_STATE(44),
        SW => INPUT_STATE(36),
        W => INPUT_STATE(35),
        NW => INPUT_STATE(34),
        IS_ALIVE => NEXT_STATE(43)
    );

    cell_5_4 : SINGLE_CELL port map(
        ME => INPUT_STATE(44),
        N => INPUT_STATE(43),
        NE => INPUT_STATE(51),
        E => INPUT_STATE(52),
        SE => INPUT_STATE(53),
        S => INPUT_STATE(45),
        SW => INPUT_STATE(37),
        W => INPUT_STATE(36),
        NW => INPUT_STATE(35),
        IS_ALIVE => NEXT_STATE(44)
    );

    cell_5_5 : SINGLE_CELL port map(
        ME => INPUT_STATE(45),
        N => INPUT_STATE(44),
        NE => INPUT_STATE(52),
        E => INPUT_STATE(53),
        SE => INPUT_STATE(54),
        S => INPUT_STATE(46),
        SW => INPUT_STATE(38),
        W => INPUT_STATE(37),
        NW => INPUT_STATE(36),
        IS_ALIVE => NEXT_STATE(45)
    );

    cell_5_6 : SINGLE_CELL port map(
        ME => INPUT_STATE(46),
        N => INPUT_STATE(45),
        NE => INPUT_STATE(53),
        E => INPUT_STATE(54),
        SE => INPUT_STATE(55),
        S => INPUT_STATE(47),
        SW => INPUT_STATE(39),
        W => INPUT_STATE(38),
        NW => INPUT_STATE(37),
        IS_ALIVE => NEXT_STATE(46)
    );

    cell_5_7 : SINGLE_CELL port map(
        ME => INPUT_STATE(47),
        N => INPUT_STATE(46),
        NE => INPUT_STATE(54),
        E => INPUT_STATE(55),
        SE => '0',
        S => '0',
        SW => '0',
        W => INPUT_STATE(39),
        NW => INPUT_STATE(38),
        IS_ALIVE => NEXT_STATE(47)
    );

    cell_6_0 : SINGLE_CELL port map(
        ME => INPUT_STATE(48),
        N => '0',
        NE => '0',
        E => INPUT_STATE(56),
        SE => INPUT_STATE(57),
        S => INPUT_STATE(49),
        SW => INPUT_STATE(41),
        W => INPUT_STATE(40),
        NW => '0',
        IS_ALIVE => NEXT_STATE(48)
    );

    cell_6_1 : SINGLE_CELL port map(
        ME => INPUT_STATE(49),
        N => INPUT_STATE(48),
        NE => INPUT_STATE(56),
        E => INPUT_STATE(57),
        SE => INPUT_STATE(58),
        S => INPUT_STATE(50),
        SW => INPUT_STATE(42),
        W => INPUT_STATE(41),
        NW => INPUT_STATE(40),
        IS_ALIVE => NEXT_STATE(49)
    );

    cell_6_2 : SINGLE_CELL port map(
        ME => INPUT_STATE(50),
        N => INPUT_STATE(49),
        NE => INPUT_STATE(57),
        E => INPUT_STATE(58),
        SE => INPUT_STATE(59),
        S => INPUT_STATE(51),
        SW => INPUT_STATE(43),
        W => INPUT_STATE(42),
        NW => INPUT_STATE(41),
        IS_ALIVE => NEXT_STATE(50)
    );

    cell_6_3 : SINGLE_CELL port map(
        ME => INPUT_STATE(51),
        N => INPUT_STATE(50),
        NE => INPUT_STATE(58),
        E => INPUT_STATE(59),
        SE => INPUT_STATE(60),
        S => INPUT_STATE(52),
        SW => INPUT_STATE(44),
        W => INPUT_STATE(43),
        NW => INPUT_STATE(42),
        IS_ALIVE => NEXT_STATE(51)
    );

    cell_6_4 : SINGLE_CELL port map(
        ME => INPUT_STATE(52),
        N => INPUT_STATE(51),
        NE => INPUT_STATE(59),
        E => INPUT_STATE(60),
        SE => INPUT_STATE(61),
        S => INPUT_STATE(53),
        SW => INPUT_STATE(45),
        W => INPUT_STATE(44),
        NW => INPUT_STATE(43),
        IS_ALIVE => NEXT_STATE(52)
    );

    cell_6_5 : SINGLE_CELL port map(
        ME => INPUT_STATE(53),
        N => INPUT_STATE(52),
        NE => INPUT_STATE(60),
        E => INPUT_STATE(61),
        SE => INPUT_STATE(62),
        S => INPUT_STATE(54),
        SW => INPUT_STATE(46),
        W => INPUT_STATE(45),
        NW => INPUT_STATE(44),
        IS_ALIVE => NEXT_STATE(53)
    );

    cell_6_6 : SINGLE_CELL port map(
        ME => INPUT_STATE(54),
        N => INPUT_STATE(53),
        NE => INPUT_STATE(61),
        E => INPUT_STATE(62),
        SE => INPUT_STATE(63),
        S => INPUT_STATE(55),
        SW => INPUT_STATE(47),
        W => INPUT_STATE(46),
        NW => INPUT_STATE(45),
        IS_ALIVE => NEXT_STATE(54)
    );

    cell_6_7 : SINGLE_CELL port map(
        ME => INPUT_STATE(55),
        N => INPUT_STATE(54),
        NE => INPUT_STATE(62),
        E => INPUT_STATE(63),
        SE => '0',
        S => '0',
        SW => '0',
        W => INPUT_STATE(47),
        NW => INPUT_STATE(46),
        IS_ALIVE => NEXT_STATE(55)
    );

    cell_7_0 : SINGLE_CELL port map(
        ME => INPUT_STATE(56),
        N => '0',
        NE => '0',
        E => '0',
        SE => '0',
        S => INPUT_STATE(57),
        SW => INPUT_STATE(49),
        W => INPUT_STATE(48),
        NW => '0',
        IS_ALIVE => NEXT_STATE(56)
    );

    cell_7_1 : SINGLE_CELL port map(
        ME => INPUT_STATE(57),
        N => INPUT_STATE(56),
        NE => '0',
        E => '0',
        SE => '0',
        S => INPUT_STATE(58),
        SW => INPUT_STATE(50),
        W => INPUT_STATE(49),
        NW => INPUT_STATE(48),
        IS_ALIVE => NEXT_STATE(57)
    );

    cell_7_2 : SINGLE_CELL port map(
        ME => INPUT_STATE(58),
        N => INPUT_STATE(57),
        NE => '0',
        E => '0',
        SE => '0',
        S => INPUT_STATE(59),
        SW => INPUT_STATE(51),
        W => INPUT_STATE(50),
        NW => INPUT_STATE(49),
        IS_ALIVE => NEXT_STATE(58)
    );

    cell_7_3 : SINGLE_CELL port map(
        ME => INPUT_STATE(59),
        N => INPUT_STATE(58),
        NE => '0',
        E => '0',
        SE => '0',
        S => INPUT_STATE(60),
        SW => INPUT_STATE(52),
        W => INPUT_STATE(51),
        NW => INPUT_STATE(50),
        IS_ALIVE => NEXT_STATE(59)
    );

    cell_7_4 : SINGLE_CELL port map(
        ME => INPUT_STATE(60),
        N => INPUT_STATE(59),
        NE => '0',
        E => '0',
        SE => '0',
        S => INPUT_STATE(61),
        SW => INPUT_STATE(53),
        W => INPUT_STATE(52),
        NW => INPUT_STATE(51),
        IS_ALIVE => NEXT_STATE(60)
    );

    cell_7_5 : SINGLE_CELL port map(
        ME => INPUT_STATE(61),
        N => INPUT_STATE(60),
        NE => '0',
        E => '0',
        SE => '0',
        S => INPUT_STATE(62),
        SW => INPUT_STATE(54),
        W => INPUT_STATE(53),
        NW => INPUT_STATE(52),
        IS_ALIVE => NEXT_STATE(61)
    );

    cell_7_6 : SINGLE_CELL port map(
        ME => INPUT_STATE(62),
        N => INPUT_STATE(61),
        NE => '0',
        E => '0',
        SE => '0',
        S => INPUT_STATE(63),
        SW => INPUT_STATE(55),
        W => INPUT_STATE(54),
        NW => INPUT_STATE(53),
        IS_ALIVE => NEXT_STATE(62)
    );

    cell_7_7 : SINGLE_CELL port map(
        ME => INPUT_STATE(63),
        N => INPUT_STATE(62),
        NE => '0',
        E => '0',
        SE => '0',
        S => '0',
        SW => '0',
        W => INPUT_STATE(55),
        NW => INPUT_STATE(54),
        IS_ALIVE => NEXT_STATE(63)
    );


-- NOTE: End of cell grid here.

end architecture RTL;