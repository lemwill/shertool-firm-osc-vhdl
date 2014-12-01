----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:24:25 11/30/2014 
-- Design Name: 
-- Module Name:    adcCtrlTest - Behavioral 
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

entity adcCtrlTest is
	Port (
		RAM_Rst   : out std_logic;
      RAM_Clk   : out std_logic;
      RAM_EN    : out std_logic;
      RAM_WEN   : out std_logic_vector(0 to 3);
      RAM_Addr  : out std_logic_vector(0 to 31);
      RAM_Din   : in  std_logic_vector(0 to 31);
      RAM_Dout  : out std_logic_vector(0 to 31);
      CLOCK     : in std_logic;
		READ_READY :out std_logic;
	   READ_START_ADDRESS: out std_logic_vector(31 downto 0)
	);
end adcCtrlTest;

architecture Behavioral of adcCtrlTest is


COMPONENT AdcController2
    Port (
        RAM_Rst   : out std_logic;
        RAM_Clk   : out std_logic;
        RAM_EN    : out std_logic;
        RAM_WEN   : out std_logic_vector(0 to 3);
        RAM_Addr  : out std_logic_vector(0 to 31);
        RAM_Din   : in  std_logic_vector(0 to 31);
        RAM_Dout  : out std_logic_vector(0 to 31);
        CLOCK     : in std_logic;
        RESET     : in std_logic;
        ADC_DATA  : in std_logic_vector(7 downto 0);
        SAMPLING_START: in std_logic;
        BUFFER_SIZE : in std_logic_vector(31 downto 0);
        TRIGGER :in std_logic;
		  READ_READY :out std_logic;
		  READ_START_ADDRESS: out std_logic_vector(31 downto 0)
    );
END COMPONENT;

signal data: unsigned(7 downto 0) := (others => '0');
signal counter: unsigned(31 downto 0) := (others => '0');
signal samplingStart: std_logic:= '0';
signal trig: std_logic:= '0'; 

begin
		AdcController2_i : AdcController2 port map (
			  RAM_Rst   => RAM_Rst,
			  RAM_Clk   => RAM_Clk,
			  RAM_EN    => RAM_EN,
			  RAM_WEN   => RAM_WEN,
			  RAM_Addr  => RAM_Addr,
			  RAM_Din   => RAM_Din,
			  RAM_Dout  => RAM_Dout,
			  CLOCK     => CLOCK,
			  RESET     => '0',
			  ADC_DATA  => std_logic_vector(data),
			  SAMPLING_START  => samplingStart,
			  BUFFER_SIZE => X"00000020",
			  TRIGGER => trig,
			  READ_READY => READ_READY,
			  READ_START_ADDRESS => READ_START_ADDRESS
        );

	process(CLOCK)
	begin 
		if rising_edge(CLOCK) then
			data <= data +1;
			
    		if(counter > 200) then
				samplingStart <= '1';
			else
				samplingStart <= '0';
			end if;
			
			if(counter = 200) then
				trig <= '1';
			else
				trig <= '0';
			end if;

			if(counter >= 1000) then
				counter <= to_unsigned(0,32); 
			else
				counter <= counter +1;
			end if;
			
		end if;
	end process;

end Behavioral;