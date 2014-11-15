--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:31:52 11/14/2014
-- Design Name:   
-- Module Name:   C:/Users/Administrateur/Vhdl/testVhdl/ClockPrescaler_tb.vhd
-- Project Name:  testVhdl
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ClockPrescaler
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
--USE ieee.numeric_std.ALL;
 
ENTITY ClockPrescaler_tb IS
END ClockPrescaler_tb;
 
ARCHITECTURE behavior OF ClockPrescaler_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ClockPrescaler
    PORT(
         Clock100MHz : IN  std_logic;
         Reset : IN  std_logic;
         Clock1Hz : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Clock100MHz : std_logic := '0';
   signal Reset : std_logic := '0';

 	--Outputs
   signal Clock1Hz : std_logic;

   -- Clock period definitions
   constant Clock100MHz_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ClockPrescaler PORT MAP (
          Clock100MHz => Clock100MHz,
          Reset => Reset,
          Clock1Hz => Clock1Hz
        );

   -- Clock process definitions
   Clock100MHz_process :process
   begin
		Clock100MHz <= '0';
		wait for Clock100MHz_period/2;
		Clock100MHz <= '1';
		wait for Clock100MHz_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		Reset <= '1';
      wait for 100 ns;	
		Reset <= '0';

      wait for Clock100MHz_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
