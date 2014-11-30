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
        TRIGGER :in std_logic
    );
end AdcController2;
 
architecture Behavioral of AdcController2 is
    signal address: unsigned(15 downto 0) := (others => '0');
    signal data: unsigned(31 downto 0) := (others => '0');
    signal writeCounter  : unsigned(15 downto 0) := (others => '0');
     
    TYPE STATE_TYPE IS (idle, sampling, postTrig);
    signal state   : STATE_TYPE;
    signal dataBuffer :STD_LOGIC_VECTOR(31 downto 0);
    
    TYPE STATE_WRITE IS (w0, w1, w2, w3);
    signal writeState  : STATE_WRITE;
    signal triggered :std_logic := '0';

begin

    RamProc: process(CLOCK, RESET) is
      begin
        if reset = '1' then
            state <= idle;
			   writeState  <= w0;
				address <=(others => '0');
				data <= (others => '0');
				writeCounter <= (others => '0');
				dataBuffer <= (others => '0');
				triggered<= '0';
				RAM_WEN <= (others => '0');
				RAM_Dout <= (others => '0');
				RAM_Addr <= (others => '0');
        elsif rising_edge(clock) then
            case state is
                when idle=>
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
                when sampling=>
                
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
                        dataBuffer <= dataBuffer OR("000000000000000000000000" & ADC_DATA );
                        RAM_Addr <= "0000000000000000" & std_logic_vector(address);
                        RAM_Dout <= dataBuffer;
                        writeState <= w0;
                        RAM_WEN <= "1111";
                        
                        if (address >= unsigned(BUFFER_SIZE)) then
                            address <= to_unsigned(0, 16);
                        else
                            address <= address+4;
                        end if;
                        
                        if triggered = '1' then
                            state <= postTrig;
                        else
                            state <= sampling;
                        end if;
                    end case;
                    
                    if TRIGGER = '1' then
                        triggered <= '1';
                    end if;
                    
                    writeCounter <= to_unsigned(0, 16);
                    
                when postTrig=>
                
                    case writeState is
                    when w0=>
                        dataBuffer <= ADC_DATA & "000000000000000000000000";
                        writeState <= w1;
                        RAM_WEN <= "0000";
                    when w1=>
                        dataBuffer <= dataBuffer OR( ADC_DATA & "0000000000000000" );
                         writeState <= w2;
                         RAM_WEN <= "0000";
                    when w2=>
                        dataBuffer <= dataBuffer OR( ADC_DATA & "00000000" );
                        writeState <= w3;
                        RAM_WEN <= "0000";
                    when w3=>
                        dataBuffer <= dataBuffer OR( ADC_DATA );
                        RAM_Addr <= "0000000000000000" & std_logic_vector(address);
                        RAM_Dout <= dataBuffer;
                        writeState <= w0;
                        RAM_WEN <= "1111";
                        writeCounter <= writeCounter + 1;
                        
                        if (address >= unsigned(BUFFER_SIZE)) then
                            address <= to_unsigned(0, 16);
                        else
                            address <= address+4;
                        end if;
                        
                        if ( writeCounter > unsigned("0" & BUFFER_SIZE(31 downto 1))) then
                            state <= idle;
                        end if;
                        
                    end case;
                    
                end case;
            --RAM_Addr <= "0000000000000000" & std_logic_vector(address);
            --RAM_Dout <= "0000000000000000" & std_logic_vector(data);
            --address <= address + 4;
            --data <= data + 4;
            
         end if;
      end process RamProc;
    
    RAM_Clk <= CLOCK;
    RAM_Rst <= '0';
    RAM_EN <= '1';
end Behavioral;
