--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:27:09 11/30/2014
-- Design Name:   
-- Module Name:   C:/Users/Administrateur/Vhdl/testVhdl/AdcController2_tb.vhd
-- Project Name:  testVhdl
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: AdcController2
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY AdcController2_tb IS
END AdcController2_tb;
 
ARCHITECTURE behavior OF AdcController2_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT AdcController2
    PORT(
         RAM_Rst : OUT  std_logic;
         RAM_Clk : OUT  std_logic;
         RAM_EN : OUT  std_logic;
         RAM_WEN : OUT  std_logic_vector(0 to 3);
         RAM_Addr : OUT  std_logic_vector(0 to 31);
         RAM_Din : IN  std_logic_vector(0 to 31);
         RAM_Dout : OUT  std_logic_vector(0 to 31);
         CLOCK : IN  std_logic;
         RESET : IN  std_logic;
         ADC_DATA : IN  std_logic_vector(7 downto 0);
         SAMPLING_START : IN  std_logic;
         BUFFER_SIZE : IN  std_logic_vector(31 downto 0);
         TRIGGER : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal RAM_Din : std_logic_vector(0 to 31) := (others => '0');
   signal CLOCK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal ADC_DATA : std_logic_vector(7 downto 0) := (others => '0');
   signal SAMPLING_START : std_logic := '0';
   signal BUFFER_SIZE : std_logic_vector(31 downto 0) := (others => '0');
   signal TRIGGER : std_logic := '0';

 	--Outputs
   signal RAM_Rst : std_logic;
   signal RAM_Clk : std_logic;
   signal RAM_EN : std_logic;
   signal RAM_WEN : std_logic_vector(0 to 3);
   signal RAM_Addr : std_logic_vector(0 to 31);
   signal RAM_Dout : std_logic_vector(0 to 31);

   -- Clock period definitions
   constant RAM_Clk_period : time := 10 ns;
   constant CLOCK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: AdcController2 PORT MAP (
          RAM_Rst => RAM_Rst,
          RAM_Clk => RAM_Clk,
          RAM_EN => RAM_EN,
          RAM_WEN => RAM_WEN,
          RAM_Addr => RAM_Addr,
          RAM_Din => RAM_Din,
          RAM_Dout => RAM_Dout,
          CLOCK => CLOCK,
          RESET => RESET,
          ADC_DATA => ADC_DATA,
          SAMPLING_START => SAMPLING_START,
          BUFFER_SIZE => BUFFER_SIZE,
          TRIGGER => TRIGGER
        );

   -- Clock process definitions
   RAM_Clk_process :process
   begin
		RAM_Clk <= '0';
		wait for RAM_Clk_period/2;
		RAM_Clk <= '1';
		wait for RAM_Clk_period/2;
   end process;
 
   CLOCK_process :process
   begin
		CLOCK <= '0';
		wait for CLOCK_period/2;
		CLOCK <= '1';
		wait for CLOCK_period/2;
		ADC_DATA <= std_logic_vector(unsigned(ADC_DATA) + 1);

   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		RESET <= '1';
      wait for 100 ns;	
		RESET <= '0';
      wait for RAM_Clk_period*10;
		
		RAM_Din <= (others => '0');
		--ADC_DATA <= X"12";
		SAMPLING_START <= '0';
		BUFFER_SIZE <= X"00000010";
		TRIGGER  <= '0';
		wait for RAM_Clk_period*1000;
		
		SAMPLING_START <= '1';
		
		wait for RAM_Clk_period*1000;
		TRIGGER  <= '1';
		SAMPLING_START <= '0';
		
		wait for RAM_Clk_period*1001;
		TRIGGER  <= '0';
		SAMPLING_START <= '1';


		wait for RAM_Clk_period*1000;
		
		SAMPLING_START <= '0';
		TRIGGER  <= '1';
		--ADC_DATA <= X"13";

      -- insert stimulus here 

      wait;
   end process;

END;
