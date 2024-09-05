library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity spiker_reader is
	Port (
		data_in1 : in STD_LOGIC_VECTOR(31 downto 0);
		data_in2 : in STD_LOGIC_VECTOR(31 downto 0);
		data_out1 : out STD_LOGIC_VECTOR(31 downto 0);
		data_out2 : out STD_LOGIC_VECTOR(31 downto 0)
	);
end spiker_reader;

architecture Behavioral of spiker_reader is
begin
	data_out1 <= data_in1;
	data_out2 <= data_in2;
end Behavioral;