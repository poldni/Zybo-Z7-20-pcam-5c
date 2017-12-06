-------------------------------------------------------------------------------
--
-- File: StoredRedCoefs.vhd
-- Author: Ioan Catuna
-- Original Project: AXI Color Correction
-- Date: 23 November 2017
--
-------------------------------------------------------------------------------
-- MIT License

-- Copyright (c) 2017 Digilent

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--
-------------------------------------------------------------------------------
--
-- Purpose:
-- This component is a ROM containing the 10-bit corrected red color values
-- for all 10-bit raw red color input values.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity StoredRedCoefs is
port(
  RomClk: in  STD_LOGIC;
  rReadEnable: in STD_LOGIC;
  rReadAddr: in  STD_LOGIC_VECTOR(9 downto 0);
  rStoredData: out STD_LOGIC_VECTOR(9 downto 0)
);
end StoredRedCoefs;

architecture rtl of StoredRedCoefs is

type RomStorage_t is array (1023 downto 0) of std_logic_vector (9 downto 0);

signal rStoredCoefs: RomStorage_t := ("11"&x"FF", "11"&x"FE", "11"&x"FD", "11"&x"FC",
"11"&x"FB", "11"&x"FA", "11"&x"F9", "11"&x"F8", "11"&x"F7", "11"&x"F6", "11"&x"F5",
"11"&x"F4", "11"&x"F3", "11"&x"F2", "11"&x"F1", "11"&x"F0", "11"&x"EF", "11"&x"EE",
"11"&x"ED", "11"&x"EC", "11"&x"EB", "11"&x"EA", "11"&x"E9", "11"&x"E8", "11"&x"E7",
"11"&x"E6", "11"&x"E5", "11"&x"E4", "11"&x"E3", "11"&x"E2", "11"&x"E1", "11"&x"E0",
"11"&x"DF", "11"&x"DE", "11"&x"DD", "11"&x"DC", "11"&x"DB", "11"&x"DA", "11"&x"D9",
"11"&x"D8", "11"&x"D7", "11"&x"D6", "11"&x"D5", "11"&x"D4", "11"&x"D3", "11"&x"D2",
"11"&x"D1", "11"&x"D0", "11"&x"CF", "11"&x"CE", "11"&x"CD", "11"&x"CC", "11"&x"CB",
"11"&x"CA", "11"&x"C9", "11"&x"C8", "11"&x"C7", "11"&x"C6", "11"&x"C5", "11"&x"C4",
"11"&x"C3", "11"&x"C2", "11"&x"C1", "11"&x"C0", "11"&x"BF", "11"&x"BE", "11"&x"BD",
"11"&x"BC", "11"&x"BB", "11"&x"BA", "11"&x"B9", "11"&x"B8", "11"&x"B7", "11"&x"B6",
"11"&x"B5", "11"&x"B4", "11"&x"B3", "11"&x"B2", "11"&x"B1", "11"&x"B0", "11"&x"AF",
"11"&x"AE", "11"&x"AD", "11"&x"AC", "11"&x"AB", "11"&x"AA", "11"&x"A9", "11"&x"A8",
"11"&x"A7", "11"&x"A6", "11"&x"A5", "11"&x"A4", "11"&x"A3", "11"&x"A2", "11"&x"A1",
"11"&x"A0", "11"&x"9F", "11"&x"9E", "11"&x"9D", "11"&x"9C", "11"&x"9B", "11"&x"9A",
"11"&x"99", "11"&x"98", "11"&x"97", "11"&x"96", "11"&x"95", "11"&x"94", "11"&x"93",
"11"&x"92", "11"&x"91", "11"&x"90", "11"&x"8F", "11"&x"8E", "11"&x"8D", "11"&x"8C",
"11"&x"8B", "11"&x"8A", "11"&x"89", "11"&x"88", "11"&x"87", "11"&x"86", "11"&x"85",
"11"&x"84", "11"&x"83", "11"&x"82", "11"&x"81", "11"&x"80", "11"&x"7F", "11"&x"7E",
"11"&x"7D", "11"&x"7C", "11"&x"7B", "11"&x"7A", "11"&x"79", "11"&x"78", "11"&x"77",
"11"&x"76", "11"&x"75", "11"&x"74", "11"&x"73", "11"&x"72", "11"&x"71", "11"&x"70",
"11"&x"6F", "11"&x"6E", "11"&x"6D", "11"&x"6C", "11"&x"6B", "11"&x"6A", "11"&x"69",
"11"&x"68", "11"&x"67", "11"&x"66", "11"&x"65", "11"&x"64", "11"&x"63", "11"&x"62",
"11"&x"61", "11"&x"60", "11"&x"5F", "11"&x"5E", "11"&x"5D", "11"&x"5C", "11"&x"5B",
"11"&x"5A", "11"&x"59", "11"&x"58", "11"&x"57", "11"&x"56", "11"&x"55", "11"&x"54",
"11"&x"53", "11"&x"52", "11"&x"51", "11"&x"50", "11"&x"4F", "11"&x"4E", "11"&x"4D",
"11"&x"4C", "11"&x"4B", "11"&x"4A", "11"&x"49", "11"&x"48", "11"&x"47", "11"&x"46",
"11"&x"45", "11"&x"44", "11"&x"43", "11"&x"42", "11"&x"41", "11"&x"40", "11"&x"3F",
"11"&x"3E", "11"&x"3D", "11"&x"3C", "11"&x"3B", "11"&x"3A", "11"&x"39", "11"&x"38",
"11"&x"37", "11"&x"36", "11"&x"35", "11"&x"34", "11"&x"33", "11"&x"32", "11"&x"31",
"11"&x"30", "11"&x"2F", "11"&x"2E", "11"&x"2D", "11"&x"2C", "11"&x"2B", "11"&x"2A",
"11"&x"29", "11"&x"28", "11"&x"27", "11"&x"26", "11"&x"25", "11"&x"24", "11"&x"23",
"11"&x"22", "11"&x"21", "11"&x"20", "11"&x"1F", "11"&x"1E", "11"&x"1D", "11"&x"1C",
"11"&x"1B", "11"&x"1A", "11"&x"19", "11"&x"18", "11"&x"17", "11"&x"16", "11"&x"15",
"11"&x"14", "11"&x"13", "11"&x"12", "11"&x"11", "11"&x"10", "11"&x"0F", "11"&x"0E",
"11"&x"0D", "11"&x"0C", "11"&x"0B", "11"&x"0A", "11"&x"09", "11"&x"08", "11"&x"07",
"11"&x"06", "11"&x"05", "11"&x"04", "11"&x"03", "11"&x"02", "11"&x"01", "11"&x"00",
"10"&x"FF", "10"&x"FE", "10"&x"FD", "10"&x"FC", "10"&x"FB", "10"&x"FA", "10"&x"F9",
"10"&x"F8", "10"&x"F7", "10"&x"F6", "10"&x"F5", "10"&x"F4", "10"&x"F3", "10"&x"F2",
"10"&x"F1", "10"&x"F0", "10"&x"EF", "10"&x"EE", "10"&x"ED", "10"&x"EC", "10"&x"EB",
"10"&x"EA", "10"&x"E9", "10"&x"E8", "10"&x"E7", "10"&x"E6", "10"&x"E5", "10"&x"E4",
"10"&x"E3", "10"&x"E2", "10"&x"E1", "10"&x"E0", "10"&x"DF", "10"&x"DE", "10"&x"DD",
"10"&x"DC", "10"&x"DB", "10"&x"DA", "10"&x"D9", "10"&x"D8", "10"&x"D7", "10"&x"D6",
"10"&x"D5", "10"&x"D4", "10"&x"D3", "10"&x"D2", "10"&x"D1", "10"&x"D0", "10"&x"CF",
"10"&x"CE", "10"&x"CD", "10"&x"CC", "10"&x"CB", "10"&x"CA", "10"&x"C9", "10"&x"C8",
"10"&x"C7", "10"&x"C6", "10"&x"C5", "10"&x"C4", "10"&x"C3", "10"&x"C2", "10"&x"C1",
"10"&x"C0", "10"&x"BF", "10"&x"BE", "10"&x"BD", "10"&x"BC", "10"&x"BB", "10"&x"BA",
"10"&x"B9", "10"&x"B8", "10"&x"B7", "10"&x"B6", "10"&x"B5", "10"&x"B4", "10"&x"B3",
"10"&x"B2", "10"&x"B1", "10"&x"B0", "10"&x"AF", "10"&x"AE", "10"&x"AD", "10"&x"AC",
"10"&x"AB", "10"&x"AA", "10"&x"A9", "10"&x"A8", "10"&x"A7", "10"&x"A6", "10"&x"A5",
"10"&x"A4", "10"&x"A3", "10"&x"A2", "10"&x"A1", "10"&x"A0", "10"&x"9F", "10"&x"9E",
"10"&x"9D", "10"&x"9C", "10"&x"9B", "10"&x"9A", "10"&x"99", "10"&x"98", "10"&x"97",
"10"&x"96", "10"&x"95", "10"&x"94", "10"&x"93", "10"&x"92", "10"&x"91", "10"&x"90",
"10"&x"8F", "10"&x"8E", "10"&x"8D", "10"&x"8C", "10"&x"8B", "10"&x"8A", "10"&x"89",
"10"&x"88", "10"&x"87", "10"&x"86", "10"&x"85", "10"&x"84", "10"&x"83", "10"&x"82",
"10"&x"81", "10"&x"80", "10"&x"7F", "10"&x"7E", "10"&x"7D", "10"&x"7C", "10"&x"7B",
"10"&x"7A", "10"&x"79", "10"&x"78", "10"&x"77", "10"&x"76", "10"&x"75", "10"&x"74",
"10"&x"73", "10"&x"72", "10"&x"71", "10"&x"70", "10"&x"6F", "10"&x"6E", "10"&x"6D",
"10"&x"6C", "10"&x"6B", "10"&x"6A", "10"&x"69", "10"&x"68", "10"&x"67", "10"&x"66",
"10"&x"65", "10"&x"64", "10"&x"63", "10"&x"62", "10"&x"61", "10"&x"60", "10"&x"5F",
"10"&x"5E", "10"&x"5D", "10"&x"5C", "10"&x"5B", "10"&x"5A", "10"&x"59", "10"&x"58",
"10"&x"57", "10"&x"56", "10"&x"55", "10"&x"54", "10"&x"53", "10"&x"52", "10"&x"51",
"10"&x"50", "10"&x"4F", "10"&x"4E", "10"&x"4D", "10"&x"4C", "10"&x"4B", "10"&x"4A",
"10"&x"49", "10"&x"48", "10"&x"47", "10"&x"46", "10"&x"45", "10"&x"44", "10"&x"43",
"10"&x"42", "10"&x"41", "10"&x"40", "10"&x"3F", "10"&x"3E", "10"&x"3D", "10"&x"3C",
"10"&x"3B", "10"&x"3A", "10"&x"39", "10"&x"38", "10"&x"37", "10"&x"36", "10"&x"35",
"10"&x"34", "10"&x"33", "10"&x"32", "10"&x"31", "10"&x"30", "10"&x"2F", "10"&x"2E",
"10"&x"2D", "10"&x"2C", "10"&x"2B", "10"&x"2A", "10"&x"29", "10"&x"28", "10"&x"27",
"10"&x"26", "10"&x"25", "10"&x"24", "10"&x"23", "10"&x"22", "10"&x"21", "10"&x"20",
"10"&x"1F", "10"&x"1E", "10"&x"1D", "10"&x"1C", "10"&x"1B", "10"&x"1A", "10"&x"19",
"10"&x"18", "10"&x"17", "10"&x"16", "10"&x"15", "10"&x"14", "10"&x"13", "10"&x"12",
"10"&x"11", "10"&x"10", "10"&x"0F", "10"&x"0E", "10"&x"0D", "10"&x"0C", "10"&x"0B",
"10"&x"0A", "10"&x"09", "10"&x"08", "10"&x"07", "10"&x"06", "10"&x"05", "10"&x"04",
"10"&x"03", "10"&x"02", "10"&x"01", "10"&x"00", "01"&x"FF", "01"&x"FE", "01"&x"FD",
"01"&x"FC", "01"&x"FB", "01"&x"FA", "01"&x"F9", "01"&x"F8", "01"&x"F7", "01"&x"F6",
"01"&x"F5", "01"&x"F4", "01"&x"F3", "01"&x"F2", "01"&x"F1", "01"&x"F0", "01"&x"EF",
"01"&x"EE", "01"&x"ED", "01"&x"EC", "01"&x"EB", "01"&x"EA", "01"&x"E9", "01"&x"E8",
"01"&x"E7", "01"&x"E6", "01"&x"E5", "01"&x"E4", "01"&x"E3", "01"&x"E2", "01"&x"E1",
"01"&x"E0", "01"&x"DF", "01"&x"DE", "01"&x"DD", "01"&x"DC", "01"&x"DB", "01"&x"DA",
"01"&x"D9", "01"&x"D8", "01"&x"D7", "01"&x"D6", "01"&x"D5", "01"&x"D4", "01"&x"D3",
"01"&x"D2", "01"&x"D1", "01"&x"D0", "01"&x"CF", "01"&x"CE", "01"&x"CD", "01"&x"CC",
"01"&x"CB", "01"&x"CA", "01"&x"C9", "01"&x"C8", "01"&x"C7", "01"&x"C6", "01"&x"C5",
"01"&x"C4", "01"&x"C3", "01"&x"C2", "01"&x"C1", "01"&x"C0", "01"&x"BF", "01"&x"BE",
"01"&x"BD", "01"&x"BC", "01"&x"BB", "01"&x"BA", "01"&x"B9", "01"&x"B8", "01"&x"B7",
"01"&x"B6", "01"&x"B5", "01"&x"B4", "01"&x"B3", "01"&x"B2", "01"&x"B1", "01"&x"B0",
"01"&x"AF", "01"&x"AE", "01"&x"AD", "01"&x"AC", "01"&x"AB", "01"&x"AA", "01"&x"A9",
"01"&x"A8", "01"&x"A7", "01"&x"A6", "01"&x"A5", "01"&x"A4", "01"&x"A3", "01"&x"A2",
"01"&x"A1", "01"&x"A0", "01"&x"9F", "01"&x"9E", "01"&x"9D", "01"&x"9C", "01"&x"9B",
"01"&x"9A", "01"&x"99", "01"&x"98", "01"&x"97", "01"&x"96", "01"&x"95", "01"&x"94",
"01"&x"93", "01"&x"92", "01"&x"91", "01"&x"90", "01"&x"8F", "01"&x"8E", "01"&x"8D",
"01"&x"8C", "01"&x"8B", "01"&x"8A", "01"&x"89", "01"&x"88", "01"&x"87", "01"&x"86",
"01"&x"85", "01"&x"84", "01"&x"83", "01"&x"82", "01"&x"81", "01"&x"80", "01"&x"7F",
"01"&x"7E", "01"&x"7D", "01"&x"7C", "01"&x"7B", "01"&x"7A", "01"&x"79", "01"&x"78",
"01"&x"77", "01"&x"76", "01"&x"75", "01"&x"74", "01"&x"73", "01"&x"72", "01"&x"71",
"01"&x"70", "01"&x"6F", "01"&x"6E", "01"&x"6D", "01"&x"6C", "01"&x"6B", "01"&x"6A",
"01"&x"69", "01"&x"68", "01"&x"67", "01"&x"66", "01"&x"65", "01"&x"64", "01"&x"63",
"01"&x"62", "01"&x"61", "01"&x"60", "01"&x"5F", "01"&x"5E", "01"&x"5D", "01"&x"5C",
"01"&x"5B", "01"&x"5A", "01"&x"59", "01"&x"58", "01"&x"57", "01"&x"56", "01"&x"55",
"01"&x"54", "01"&x"53", "01"&x"52", "01"&x"51", "01"&x"50", "01"&x"4F", "01"&x"4E",
"01"&x"4D", "01"&x"4C", "01"&x"4B", "01"&x"4A", "01"&x"49", "01"&x"48", "01"&x"47",
"01"&x"46", "01"&x"45", "01"&x"44", "01"&x"43", "01"&x"42", "01"&x"41", "01"&x"40",
"01"&x"3F", "01"&x"3E", "01"&x"3D", "01"&x"3C", "01"&x"3B", "01"&x"3A", "01"&x"39",
"01"&x"38", "01"&x"37", "01"&x"36", "01"&x"35", "01"&x"34", "01"&x"33", "01"&x"32",
"01"&x"31", "01"&x"30", "01"&x"2F", "01"&x"2E", "01"&x"2D", "01"&x"2C", "01"&x"2B",
"01"&x"2A", "01"&x"29", "01"&x"28", "01"&x"27", "01"&x"26", "01"&x"25", "01"&x"24",
"01"&x"23", "01"&x"22", "01"&x"21", "01"&x"20", "01"&x"1F", "01"&x"1E", "01"&x"1D",
"01"&x"1C", "01"&x"1B", "01"&x"1A", "01"&x"19", "01"&x"18", "01"&x"17", "01"&x"16",
"01"&x"15", "01"&x"14", "01"&x"13", "01"&x"12", "01"&x"11", "01"&x"10", "01"&x"0F",
"01"&x"0E", "01"&x"0D", "01"&x"0C", "01"&x"0B", "01"&x"0A", "01"&x"09", "01"&x"08",
"01"&x"07", "01"&x"06", "01"&x"05", "01"&x"04", "01"&x"03", "01"&x"02", "01"&x"01",
"01"&x"00", "00"&x"FF", "00"&x"FE", "00"&x"FD", "00"&x"FC", "00"&x"FB", "00"&x"FA",
"00"&x"F9", "00"&x"F8", "00"&x"F7", "00"&x"F6", "00"&x"F5", "00"&x"F4", "00"&x"F3",
"00"&x"F2", "00"&x"F1", "00"&x"F0", "00"&x"EF", "00"&x"EE", "00"&x"ED", "00"&x"EC",
"00"&x"EB", "00"&x"EA", "00"&x"E9", "00"&x"E8", "00"&x"E7", "00"&x"E6", "00"&x"E5",
"00"&x"E4", "00"&x"E3", "00"&x"E2", "00"&x"E1", "00"&x"E0", "00"&x"DF", "00"&x"DE",
"00"&x"DD", "00"&x"DC", "00"&x"DB", "00"&x"DA", "00"&x"D9", "00"&x"D8", "00"&x"D7",
"00"&x"D6", "00"&x"D5", "00"&x"D4", "00"&x"D3", "00"&x"D2", "00"&x"D1", "00"&x"D0",
"00"&x"CF", "00"&x"CE", "00"&x"CD", "00"&x"CC", "00"&x"CB", "00"&x"CA", "00"&x"C9",
"00"&x"C8", "00"&x"C7", "00"&x"C6", "00"&x"C5", "00"&x"C4", "00"&x"C3", "00"&x"C2",
"00"&x"C1", "00"&x"C0", "00"&x"BF", "00"&x"BE", "00"&x"BD", "00"&x"BC", "00"&x"BB",
"00"&x"BA", "00"&x"B9", "00"&x"B8", "00"&x"B7", "00"&x"B6", "00"&x"B5", "00"&x"B4",
"00"&x"B3", "00"&x"B2", "00"&x"B1", "00"&x"B0", "00"&x"AF", "00"&x"AE", "00"&x"AD",
"00"&x"AC", "00"&x"AB", "00"&x"AA", "00"&x"A9", "00"&x"A8", "00"&x"A7", "00"&x"A6",
"00"&x"A5", "00"&x"A4", "00"&x"A3", "00"&x"A2", "00"&x"A1", "00"&x"A0", "00"&x"9F",
"00"&x"9E", "00"&x"9D", "00"&x"9C", "00"&x"9B", "00"&x"9A", "00"&x"99", "00"&x"98",
"00"&x"97", "00"&x"96", "00"&x"95", "00"&x"94", "00"&x"93", "00"&x"92", "00"&x"91",
"00"&x"90", "00"&x"8F", "00"&x"8E", "00"&x"8D", "00"&x"8C", "00"&x"8B", "00"&x"8A",
"00"&x"89", "00"&x"88", "00"&x"87", "00"&x"86", "00"&x"85", "00"&x"84", "00"&x"83",
"00"&x"82", "00"&x"81", "00"&x"80", "00"&x"7F", "00"&x"7E", "00"&x"7D", "00"&x"7C",
"00"&x"7B", "00"&x"7A", "00"&x"79", "00"&x"78", "00"&x"77", "00"&x"76", "00"&x"75",
"00"&x"74", "00"&x"73", "00"&x"72", "00"&x"71", "00"&x"70", "00"&x"6F", "00"&x"6E",
"00"&x"6D", "00"&x"6C", "00"&x"6B", "00"&x"6A", "00"&x"69", "00"&x"68", "00"&x"67",
"00"&x"66", "00"&x"65", "00"&x"64", "00"&x"63", "00"&x"62", "00"&x"61", "00"&x"60",
"00"&x"5F", "00"&x"5E", "00"&x"5D", "00"&x"5C", "00"&x"5B", "00"&x"5A", "00"&x"59",
"00"&x"58", "00"&x"57", "00"&x"56", "00"&x"55", "00"&x"54", "00"&x"53", "00"&x"52",
"00"&x"51", "00"&x"50", "00"&x"4F", "00"&x"4E", "00"&x"4D", "00"&x"4C", "00"&x"4B",
"00"&x"4A", "00"&x"49", "00"&x"48", "00"&x"47", "00"&x"46", "00"&x"45", "00"&x"44",
"00"&x"43", "00"&x"42", "00"&x"41", "00"&x"40", "00"&x"3F", "00"&x"3E", "00"&x"3D",
"00"&x"3C", "00"&x"3B", "00"&x"3A", "00"&x"39", "00"&x"38", "00"&x"37", "00"&x"36",
"00"&x"35", "00"&x"34", "00"&x"33", "00"&x"32", "00"&x"31", "00"&x"30", "00"&x"2F",
"00"&x"2E", "00"&x"2D", "00"&x"2C", "00"&x"2B", "00"&x"2A", "00"&x"29", "00"&x"28",
"00"&x"27", "00"&x"26", "00"&x"25", "00"&x"24", "00"&x"23", "00"&x"22", "00"&x"21",
"00"&x"20", "00"&x"1F", "00"&x"1E", "00"&x"1D", "00"&x"1C", "00"&x"1B", "00"&x"1A",
"00"&x"19", "00"&x"18", "00"&x"17", "00"&x"16", "00"&x"15", "00"&x"14", "00"&x"13",
"00"&x"12", "00"&x"11", "00"&x"10", "00"&x"0F", "00"&x"0E", "00"&x"0D", "00"&x"0C",
"00"&x"0B", "00"&x"0A", "00"&x"09", "00"&x"08", "00"&x"07", "00"&x"06", "00"&x"05",
"00"&x"04", "00"&x"03", "00"&x"02", "00"&x"01", "00"&x"00");

attribute rom_style : string;
attribute rom_style of rStoredCoefs : signal is "block";

begin

ReadData: process (RomClk)
begin
  if rising_edge(RomClk) then
    if rReadEnable = '1' then
      rStoredData <= rStoredCoefs(to_integer(unsigned(rReadAddr)));
    end if;
  end if;
end process ReadData;

end rtl;

