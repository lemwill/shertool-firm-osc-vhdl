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

entity AdcController2 is
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
end AdcController2;
 
architecture Behavioral of AdcController2 is
    signal address: unsigned(15 downto 0) := (others => '0');
    signal data: unsigned(31 downto 0) := (others => '0');
    signal preTriggerCounter  : unsigned(15 downto 0) := (others => '0');
    signal postTriggerCounter  : unsigned(15 downto 0) := (others => '0');
     
    TYPE STATE_TYPE IS (idle, sampling, postTrig);
    signal state   : STATE_TYPE;
    signal dataBuffer :STD_LOGIC_VECTOR(31 downto 0);
    
    TYPE STATE_WRITE IS (w0, w1, w2, w3);
    signal writeState  : STATE_WRITE;
    signal triggered :std_logic := '0';
	 signal startSampling: std_logic := '0'; 
begin
	 RamProc: process(CLOCK, RESET) is
      begin
        if reset = '1' then
            state <= idle;
			   writeState  <= w0;
				address <=(others => '0');
				data <= (others => '0');
				preTriggerCounter <= (others => '0');
				postTriggerCounter <= (others => '0');
				dataBuffer <= (others => '0');
				triggered<= '0';
				RAM_WEN <= (others => '0');
				RAM_Dout <= (others => '0');
				RAM_Addr <= (others => '0');
				startSampling <= '0';
				READ_START_ADDRESS <= (others => '0');
        elsif rising_edge(clock) then
            case state is
				
					 -- In this state the PC can read the data, and request a new sampling
                when idle =>
                    if SAMPLING_START = '1' then
                        state <= sampling;
                    else
                        state <= idle;
                    end if;
                    triggered <= '0';
                    address <=(others => '0');
						  RAM_Dout <= (others => '0');
                    RAM_WEN <= "0000";
                    RAM_Addr <= (others => '0');
						  preTriggerCounter <=(others => '0');

						when sampling =>
						 -- The ADC is sampling in the circular buffer before the trigger
						 case writeState is
							  when w0=>
									dataBuffer <= ADC_DATA & "000000000000000000000000";
									writeState <= w1;
									RAM_WEN <= "0000";
							  when w1=>
									dataBuffer <=  dataBuffer OR( "00000000" & ADC_DATA & "0000000000000000" );
									 writeState <= w2;
									 RAM_WEN <= "0000";
							  when w2=>
									dataBuffer <= dataBuffer OR("0000000000000000" &  ADC_DATA & "00000000" );
									writeState <= w3;
									RAM_WEN <= "0000";
							  when w3=>
									RAM_Addr <= "0000000000000000" & std_logic_vector(address);
									RAM_Dout <= dataBuffer OR("000000000000000000000000" & ADC_DATA );
									writeState <= w0;
									RAM_WEN <= "1111";
									
									if (address >= unsigned(BUFFER_SIZE)-4) then
										 address <= to_unsigned(0, 16);
									else
										 address <= address+4;
									end if;
									
									preTriggerCounter <= preTriggerCounter + 4;
									
									if triggered = '1' AND ( preTriggerCounter >= unsigned("0" & BUFFER_SIZE(31 downto 1) )-4) then
										 state <= postTrig;
									else
										 state <= sampling;
									end if;
						  end case;
                    
                    if TRIGGER = '1' then
                        triggered <= '1';
                    end if;
                    
                    postTriggerCounter <= to_unsigned(0, 16);
                    
  					 -- The ADC is fulling the second half of the circular buffer
                when postTrig=>
                
                    case writeState is
                    when w0=>
                        dataBuffer <= ADC_DATA & "000000000000000000000000";
                        writeState <= w1;
                        RAM_WEN <= "0000";
                    when w1=>
                        dataBuffer <= dataBuffer OR( "00000000" & ADC_DATA & "0000000000000000" );
                         writeState <= w2;
                         RAM_WEN <= "0000";
                    when w2=>
                        dataBuffer <= dataBuffer OR("0000000000000000" &  ADC_DATA & "00000000" );
                        writeState <= w3;
                        RAM_WEN <= "0000";
                    when w3=>
                        RAM_Addr <= "0000000000000000" & std_logic_vector(address);
								READ_START_ADDRESS <= "0000000000000000" & std_logic_vector(address);

                        RAM_Dout <= dataBuffer OR("000000000000000000000000" & ADC_DATA );
                        writeState <= w0;
                        RAM_WEN <= "1111";
                        postTriggerCounter <= postTriggerCounter + 4;
								
                        if (address >= unsigned(BUFFER_SIZE)-4) then
										 address <= to_unsigned(0, 16);
								else
										 address <= address+4;
								end if;
									
                        if ( postTriggerCounter >= unsigned("0" & BUFFER_SIZE(31 downto 1) )-4) then
                            state <= idle;


                        end if;
                    end case;
                end case;
            
				-- A transition of SAMPLING_START must occur during the idle state
				if (SAMPLING_START = '1') and (startSampling = '0') and (state= idle )then
					startSampling <= '1';
				elsif (state /= idle) then
					startSampling <= '0';
				end if;
				
				if (state = idle)then
					READ_READY <= '1';

				else 
					READ_READY <= '0';
				end if;
				

         end if;
      end process RamProc;
    
    RAM_Clk <= CLOCK;
    RAM_Rst <= '0';
    RAM_EN <= '1';

end Behavioral;
