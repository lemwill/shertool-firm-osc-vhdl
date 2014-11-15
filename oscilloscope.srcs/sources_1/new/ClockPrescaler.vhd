----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:28:13 11/14/2014 
-- Design Name: 
-- Module Name:    ClockPrescaler - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ClockPrescaler is
    Port ( Clock100MHz : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Clock1Hz : out  STD_LOGIC);
end ClockPrescaler;

architecture Behavioral of ClockPrescaler is
	signal prescaler : unsigned(27 downto 0);
	signal clock1Hz_sig : std_logic;
	constant division1Hz : integer := 50000000;

begin
		gen_clk : process (Clock100MHz, Reset)
	
		begin
			if Reset = '1' then
				clock1Hz_sig   <= '0';
				prescaler   <= (others => '0');
			elsif rising_edge(Clock100MHz) then
				if prescaler = division1Hz then    
					prescaler   <= (others => '0');
					clock1Hz_sig   <= not clock1Hz_sig;
				else
					prescaler <= prescaler + "1";
				end if;
			end if;
		end process gen_clk;		

Clock1Hz <= clock1Hz_sig	;	
end Behavioral;
