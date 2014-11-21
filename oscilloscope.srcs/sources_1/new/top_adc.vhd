----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:53:01 11/14/2014 
-- Design Name: 
-- Module Name:    top - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity top_adc is
    Port ( Clock100MHz : in  STD_LOGIC;
           ADC_CH1D_P: in STD_LOGIC_VECTOR (7 downto 0);
           ADC_CH1D_N: in STD_LOGIC_VECTOR (7 downto 0);
           Switch : in  STD_LOGIC;
           Led : out  STD_LOGIC_VECTOR (3 downto 0));
end top_adc;

architecture structure of top_adc is

COMPONENT ClockPrescaler 	
	Port ( Clock100MHz : in  STD_LOGIC;
          Reset : in  STD_LOGIC;
          Clock1Hz : out  STD_LOGIC);
END COMPONENT;

signal data_chan1: STD_LOGIC_VECTOR (7 downto 0);
signal data_chan2: STD_LOGIC_VECTOR (7 downto 0);
signal data_clock: STD_LOGIC;


begin
    IBUFDS_CHAN1: for i in adc_data'range generate
        INPUT_BUFFER: IBUFDS 
        GENERIC MAP(
            DIFF_TERM => true,
            IOSTANDARD => "LVDS_25"
        )
        PORT MAP(
            I  => ADC_CH1D_P(i),
            IB => ADC_CH1D_N(i),
            O  => data_chan1(i)
        );
    end generate;
    
    IBUFDS_CHAN2: for i in adc_data'range generate
        INPUT_BUFFER: IBUFDS 
        GENERIC MAP(
            DIFF_TERM => TRUE,
            IOSTANDARD => "LVDS_25"
        )
        PORT MAP(
            I  => ADC_CH1D_P(i),
            IB => ADC_CH1D_N(i),
            O  => data_chan2(i)
        );
    end generate;
        
    DIFF_CLK_BUFFER : IBUFGDS
    generic map (
       DIFF_TERM => TRUE,
       IOSTANDARD => "DEFAULT")
    port map (
       O => O, 
       I => I, 
       IB => IB 
    );
            
	CLOCK_PRESCALER_1 : ClockPrescaler PORT MAP(Clock100MHz => Clock100MHz,
			                                    Reset => '0',
								                Clock1Hz => Led(0));

   --adc_sig <= ADC_CH1D_P(0);
   --Led(1) <= adc_data(0);
   
   --switch_sig <= Switch;
   Led(2) <= Switch;
end structure;
