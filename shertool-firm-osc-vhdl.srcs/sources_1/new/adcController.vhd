----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/28/2014 10:37:37 PM
-- Design Name: 
-- Module Name: AdcController - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

entity AdcController is
    Port (
        RAM_Rst   : out std_logic;
        RAM_Clk   : out std_logic;
        RAM_EN    : out std_logic;
        RAM_WEN   : out std_logic_vector(0 to 3);
        RAM_Addr  : out std_logic_vector(0 to 31);
        RAM_Din   : in  std_logic_vector(0 to 31);
        RAM_Dout  : out std_logic_vector(0 to 31);
        CLOCK     : in std_logic
    );
end AdcController;

architecture Behavioral of AdcController is
signal address: unsigned(15 downto 0) := (others => '0');
signal data: unsigned(15 downto 0) := (others => '0');
begin

    RamProc: process(CLOCK) is
    
      begin
        if rising_edge(clock) then

            RAM_Addr <= "0000000000000000" & std_logic_vector(address);
            RAM_Dout <= "0000000000000000" & std_logic_vector(data);
            address <= address + 4;
            data <= data + 1;
            
         end if;
      end process RamProc;
    
    RAM_WEN <= "1111";
    RAM_Clk <= CLOCK;
    RAM_Rst <= '0';
    RAM_EN <= '1';
end Behavioral;
