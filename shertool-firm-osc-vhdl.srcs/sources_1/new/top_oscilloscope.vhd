library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package Types is
    type BYTE_ARRAY is array (natural range <>) of STD_LOGIC_VECTOR(7 downto 0);
end package Types;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VComponents.all;
use work.Types.all;

entity osc_microblaze_stub is
  port (
    DAC_SCLK:        out STD_LOGIC;
    DAC_SYNC:        out STD_LOGIC;
    DAC_RST:         out STD_LOGIC;
    DAC_DIN:         out STD_LOGIC;
    CH1_PGA_CS:      out STD_LOGIC;
    CH2_PGA_MOSI:    out STD_LOGIC;
    CH2_PGA_MISO:    in  STD_LOGIC;
    CH2_PGA_SCK:     out STD_LOGIC;
    CH2_PGA_CS:      out STD_LOGIC;
    FPGA_ADC_CSC:    out STD_LOGIC;
    FPGA_ADC_RST:    out STD_LOGIC;
    FPGA_ADC_SCLK:   out STD_LOGIC;
    FPGA_ADC_SDA:    out STD_LOGIC;
    FPGA_ADC_PD:     out STD_LOGIC;    
    ADC_DATA_P:      in BYTE_ARRAY (1 downto 0);
    ADC_DATA_N:      in BYTE_ARRAY (1 downto 0);
    ADC_DCLK_P:      in STD_LOGIC; 
    ADC_DCLK_N:      in STD_LOGIC;
    ADC_OUT_R_P:     in STD_LOGIC;
    ADC_OUT_R_N:     in STD_LOGIC;
    CH1_TRIG_P:      in STD_LOGIC;
    CH1_TRIG_N:      in STD_LOGIC;
    CH2_TRIG_P:      in STD_LOGIC;
    CH2_TRIG_N:      in STD_LOGIC;
    EXT_TRIG_P:      in STD_LOGIC;
    EXT_TRIG_N:      in STD_LOGIC;
    Main_FPGA_CLK_P: in STD_LOGIC;
    Main_FPGA_CLK_N: in STD_LOGIC;
    SYNC_IN_P:       in STD_LOGIC;
    SYNC_IN_N:       in STD_LOGIC;
    TEST_CLK_OUT_P:  out STD_LOGIC;
    TEST_CLK_OUT_N:  out STD_LOGIC;
    UART_TX : out std_logic;
    UART_RX : in std_logic
  );
end osc_microblaze_stub;
 
architecture STRUCTURE of osc_microblaze_stub is

COMPONENT Oscilloscope
    port (
      Clock100Mhz: in STD_LOGIC;
      Clock1Hz: out STD_LOGIC;
      RS232_Uart_1_sin : in std_logic;
      RS232_Uart_1_sout : out std_logic;
      DacSclk: out std_logic;
      DacSync: out std_logic;
      DacRst: out std_logic;
      DacDin: out std_logic;
      Ch1PgaCs: out std_logic;
      Ch2PgaMosi: out std_logic;
      Ch2PgaMiso: in std_logic;
      Ch2PgaSck: out std_logic;
      Ch2PgaCs: out std_logic;
      AdcCsc: out std_logic;
      AdcRst: out std_logic;
      AdcSclk: out std_logic;
      AdcSda: out std_logic
    );
  END COMPONENT;

 
 signal data_chan1: STD_LOGIC_VECTOR (7 downto 0);
 signal data_chan2: STD_LOGIC_VECTOR (7 downto 0);
 signal data_clock: STD_LOGIC;
 signal adcData: BYTE_ARRAY (1 downto 0);
 signal adcClk: STD_LOGIC;
 signal clock100Mhz: STD_LOGIC;
 signal clock1Hz: STD_LOGIC;
 signal adcOutR: STD_LOGIC;
 signal extTrig: STD_LOGIC;
 signal ch1Trig: STD_LOGIC;
 signal ch2Trig: STD_LOGIC;
 signal uartTx: STD_LOGIC;
 signal syncClkIn: STD_LOGIC;
 constant channelQty : integer := 2;

begin
    oscilloscope_impl : Oscilloscope
    port map (
      Clock100Mhz=>clock100Mhz,
      Clock1Hz=>clock1Hz,
      RS232_Uart_1_sout=>UART_TX,
      RS232_Uart_1_sin=>UART_RX,
      DacSclk => DAC_SCLK,
      DacSync =>DAC_SYNC,
      DacRst => DAC_RST,
      DacDin => DAC_DIN,
      Ch1PgaCs => CH1_PGA_CS,
      Ch2PgaMiso => CH2_PGA_MISO,
      Ch2PgaMosi => CH2_PGA_MOSI,
      Ch2PgaSck => CH2_PGA_SCK,
      Ch2PgaCs => CH2_PGA_CS,
      AdcCsc =>FPGA_ADC_CSC,
      AdcRst => FPGA_ADC_RST,
      AdcSclk =>FPGA_ADC_SCLK,
      AdcSda => FPGA_ADC_SDA
    );
    
    --------------- ADC DATA ------------------
    CHAN : for chan in 0 to (channelQty-1) generate
        PIN : for pin in 0 to 7 generate
            INPUT_BUFFER: IBUFDS 
            GENERIC MAP(
                DIFF_TERM => true)
            PORT MAP(
                I  => ADC_DATA_P(chan)(pin),
                IB => ADC_DATA_N(chan)(pin),
                O  => adcData(chan)(pin)
            );
        end generate;
    end generate;
    
    
    --------------- MAIN CLOCK -----------------
    MAIN_FPGA_CLK_BUFFER : IBUFGDS
    generic map (
       DIFF_TERM => TRUE)
    port map (
       O => clock100Mhz, 
       I => Main_FPGA_CLK_P, 
       IB => Main_FPGA_CLK_N 
    );
        
    ------------- TEST CLOCK OUT ---------------
    TEST_CLK_OUT_BUFFER : OBUFDS
    port map (
        O => TEST_CLK_OUT_P,
        OB => TEST_CLK_OUT_N,
        I => clock1Hz
    );
    
    --------------- ADC CLOCK ------------------
    DIFF_CLK_BUFFER : IBUFGDS
    generic map (
       DIFF_TERM => TRUE)
    port map (
       O => adcClk, 
       I => ADC_DCLK_P, 
       IB => ADC_DCLK_N 
    );
    
    --------------- ADC OUT R ------------------
    ADC_OUT_R_BUFFER : IBUFDS
    generic map (
       DIFF_TERM => TRUE)
    port map (
       O => adcOutR, 
       I => ADC_OUT_R_P, 
       IB => ADC_OUT_R_N 
    );
    
    --------------- Triggers ------------------
    CH1_TRIG_BUFFER : IBUFGDS
    generic map (
       DIFF_TERM => TRUE)
    port map (
       O => ch1Trig, 
       I => CH1_TRIG_P, 
       IB => CH1_TRIG_N 
    );
    
    CH2_TRIG_BUFFER : IBUFDS
    generic map (
       DIFF_TERM => TRUE)
    port map (
       O => ch2Trig, 
       I => CH2_TRIG_P, 
       IB => CH2_TRIG_N 
    );
    
    EXT_TRIG_BUFFER : IBUFDS
    generic map (
       DIFF_TERM => TRUE)
    port map (
       O => extTrig, 
       I => EXT_TRIG_P, 
       IB => EXT_TRIG_N
    );
    
    --------------- Sync In ------------------
    SYNC_IN_BUFFER : IBUFGDS
    generic map (
       DIFF_TERM => TRUE)
    port map (
       O => syncClkIn, 
       I => SYNC_IN_P, 
       IB => SYNC_IN_N
    );
               
    FPGA_ADC_PD <= '1';

end architecture STRUCTURE;
