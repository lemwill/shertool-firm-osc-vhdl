
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity Oscilloscope is
  port (
    Clock100Mhz: in STD_LOGIC;
    Clock1Hz: out STD_LOGIC;
    RS232_Uart_1_sout : out std_logic;
    RS232_Uart_1_sin : in std_logic;
    DacSclk: out std_logic;
    DacSync: inout std_logic;
    DacRst: inout std_logic;
    DacEn: inout std_logic;
    DacDin: out std_logic;
    Ch1PgaCs: inout std_logic;
    Ch2PgaMosi: out std_logic;
    Ch2PgaMiso: in std_logic;
    Ch2PgaSck: out std_logic;
    Ch2PgaCs: inout std_logic;
    AdcCsc: inout std_logic;
    AdcRst: inout std_logic;
    AdcSclk: out std_logic;
    AdcSda: out std_logic;
    AdcCal: inout std_logic;
    AdcCalActive: inout std_logic;
    AdcPd: inout std_logic;
    AdcPdq: inout std_logic;
    Ch1Relay_N: inout std_logic;
    Ch1AcCoup_N: inout std_logic;
    Ch2Relay_N: inout std_logic;
    Ch2AcCoup_N: inout std_logic;
    Ldac: inout std_logic;
    AdcData: in std_Logic_vector(7 downto 0);
    AdcClk: in std_logic
  );
end Oscilloscope;

architecture STRUCTURE of Oscilloscope is
    COMPONENT adcCtrlTest
    Port (
        RAM_Rst   : out std_logic;
        RAM_Clk   : out std_logic;
        RAM_EN    : out std_logic;
        RAM_WEN   : out std_logic_vector(0 to 3);
        RAM_Addr  : out std_logic_vector(0 to 31);
        RAM_Din   : in  std_logic_vector(0 to 31);
        RAM_Dout  : out std_logic_vector(0 to 31);
        CLOCK     : in std_logic;
        ADC_DATA  : in std_logic_vector(7 downto 0);
        READ_READY :out std_logic;
        READ_START_ADDRESS: out std_logic_vector(31 downto 0);
        SAMPLING_START: in std_logic;
        BUFFER_SIZE : in std_logic_vector(31 downto 0);
        DOWN_SAMPLING : in std_logic_vector(31 downto 0);
        STATE : out std_logic_vector(31 downto 0)
  );
  
  END COMPONENT;
  COMPONENT ClockPrescaler 	
  Port ( 
      Clock100MHz : in  STD_LOGIC;
      Reset :       in  STD_LOGIC;
      Clock1Hz :    out  STD_LOGIC
      );
  END COMPONENT;

--  component AdcController 
--  Port (
--      RAM_Rst   : out std_logic;
--      RAM_Clk   : out std_logic;
--      RAM_EN    : out std_logic;
--      RAM_WEN   : out std_logic_vector(0 to 3);
--      RAM_Addr  : out std_logic_vector(0 to 31);
--      RAM_Din   : in  std_logic_vector(0 to 31);
--      RAM_Dout  : out std_logic_vector(0 to 31);
--      CLOCK     : in std_logic
--  );
--  end component;
  
   component osc_microblaze 
    port (
      RESET : in std_logic;
      RS232_Uart_1_sin : in std_logic;
      RS232_Uart_1_sout : out std_logic;
      axi_bram_ctrl_0_bram_block_1_BRAM_Rst_B_pin : in std_logic;
      axi_bram_ctrl_0_bram_block_1_BRAM_Clk_B_pin : in std_logic;
      axi_bram_ctrl_0_bram_block_1_BRAM_EN_B_pin : in std_logic;
      axi_bram_ctrl_0_bram_block_1_BRAM_WEN_B_pin : in std_logic_vector(0 to 3);
      axi_bram_ctrl_0_bram_block_1_BRAM_Addr_B_pin : in std_logic_vector(0 to 31);
      axi_bram_ctrl_0_bram_block_1_BRAM_Din_B_pin : out std_logic_vector(0 to 31);
      axi_bram_ctrl_0_bram_block_1_BRAM_Dout_B_pin : in std_logic_vector(0 to 31);
      CLK : in std_logic;
      axi_spi_pga_SCK_pin : out std_logic;
      axi_spi_pga_MOSI_pin : out std_logic;
      axi_spi_pga_MISO_pin : in std_logic;
      axi_spi_pga_SS_pin : out std_logic_vector(1 downto 0);
      axi_spi_dac_SCK_pin : out std_logic;
      axi_spi_dac_MOSI_pin : out std_logic;
      axi_spi_dac_SS_pin : out std_logic;
      axi_spi_adc_SCK_pin : out std_logic;
      axi_spi_adc_MOSI_pin : out std_logic;
      axi_spi_adc_SS_pin : out std_logic;
      axi_gpio_0_GPIO_IO_pin : inout std_logic_vector(15 downto 0);
      axi_gpio_0_GPIO2_IO_O_pin : out std_logic_vector(0 to 0);
      adccontroller3_0_READ_ADDRESS_pin : in std_logic_vector(31 downto 0);
      adccontroller3_0_STATE_pin : in std_logic_vector(31 downto 0);
      adccontroller3_0_BUFFER_SIZE_pin : out std_logic_vector(31 downto 0);
      adccontroller3_0_DOWN_SAMPLING_pin : out std_logic_vector(31 downto 0)

    );
  end component;

  attribute BOX_TYPE : STRING;
  attribute BOX_TYPE of osc_microblaze : component is "user_black_box";
 
  signal RAM_Rst   : std_logic;
  signal RAM_Clk   : std_logic;
  signal RAM_EN    : std_logic;
  signal RAM_WEN   : std_logic_vector(0 to 3);
  signal RAM_Addr  : std_logic_vector(0 to 31);
  signal RAM_Din   : std_logic_vector(0 to 31);
  signal RAM_Dout  : std_logic_vector(0 to 31);

  signal readReady: std_logic;
  signal readStartAddress: std_logic_vector(31 downto 0);
  signal bufferSize: std_logic_vector(31 downto 0);
  signal downSampling: std_logic_vector(31 downto 0);
  signal state: std_logic_vector(31 downto 0);
  signal samplingStart: std_logic;
  
begin
  osc_microblaze_i : osc_microblaze
    port map (
      RESET => '1',
      RS232_Uart_1_sin => RS232_Uart_1_sin,
      RS232_Uart_1_sout => RS232_Uart_1_sout,
      axi_bram_ctrl_0_bram_block_1_BRAM_Rst_B_pin => RAM_Rst,
      axi_bram_ctrl_0_bram_block_1_BRAM_Clk_B_pin => RAM_Clk,
      axi_bram_ctrl_0_bram_block_1_BRAM_EN_B_pin => RAM_EN,
      axi_bram_ctrl_0_bram_block_1_BRAM_WEN_B_pin => RAM_WEN,
      axi_bram_ctrl_0_bram_block_1_BRAM_Addr_B_pin => RAM_Addr,
      axi_bram_ctrl_0_bram_block_1_BRAM_Din_B_pin => RAM_Din,
      axi_bram_ctrl_0_bram_block_1_BRAM_Dout_B_pin => RAM_Dout,
      CLK => Clock100Mhz,
      axi_spi_pga_SCK_pin => Ch2PgaSck,
      axi_spi_pga_MOSI_pin => Ch2PgaMosi,
      axi_spi_pga_MISO_pin => Ch2PgaMiso,
      axi_spi_dac_SCK_pin => DacSclk,
      axi_spi_dac_MOSI_pin => DacDin,
      axi_spi_adc_SCK_pin => AdcSclk,
      axi_spi_adc_MOSI_pin => AdcSda,         
      axi_gpio_0_GPIO_IO_pin(0) => AdcRst,            
      axi_gpio_0_GPIO_IO_pin(1) => AdcCal,            
      axi_gpio_0_GPIO_IO_pin(2) => AdcCalActive,            
      axi_gpio_0_GPIO_IO_pin(3) => AdcPd,            
      axi_gpio_0_GPIO_IO_pin(4) => AdcPdq,            
      axi_gpio_0_GPIO_IO_pin(5) => Ch1Relay_N,            
      axi_gpio_0_GPIO_IO_pin(6) => Ch1AcCoup_N,            
      axi_gpio_0_GPIO_IO_pin(7) => Ch2Relay_N,            
      axi_gpio_0_GPIO_IO_pin(8) => Ch2AcCoup_N,            
      axi_gpio_0_GPIO_IO_pin(9) => Ldac,            
      axi_gpio_0_GPIO_IO_pin(10) => DacSync,            
      axi_gpio_0_GPIO_IO_pin(11) => DacRst,            
      axi_gpio_0_GPIO_IO_pin(12) => Ch1PgaCs,
      axi_gpio_0_GPIO_IO_pin(13) => Ch2PgaCs,
      axi_gpio_0_GPIO_IO_pin(14) => DacEn,
      axi_gpio_0_GPIO_IO_pin(15) => AdcCsc,
      axi_gpio_0_GPIO2_IO_O_pin(0) => samplingStart,
      adccontroller3_0_READ_ADDRESS_pin => readStartAddress,
      adccontroller3_0_STATE_pin => state,
      adccontroller3_0_BUFFER_SIZE_pin => bufferSize,
      adccontroller3_0_DOWN_SAMPLING_pin => downSampling
    );
    
    --    adcController_i: AdcController
    --    port map (
    --        RAM_Rst => RAM_Rst,
    --        RAM_Clk => RAM_Clk,
    --        RAM_EN => RAM_EN,
    --        RAM_WEN => RAM_WEN,
    --        RAM_Addr => RAM_Addr,
    --        RAM_Din => RAM_Din,
    --        RAM_Dout => RAM_Dout,
    --        CLOCK => Clock100Mhz
    --    );
    
    adcController_i: adcCtrlTest
    port map (
        RAM_Rst => RAM_Rst,
        RAM_Clk => RAM_Clk,
        RAM_EN => RAM_EN,
        RAM_WEN => RAM_WEN,
        RAM_Addr => RAM_Addr,
        RAM_Din => RAM_Din,
        RAM_Dout => RAM_Dout,
        CLOCK => AdcClk,
        READ_READY => readReady,
        ADC_DATA => AdcData,
        SAMPLING_START => samplingStart,
        READ_START_ADDRESS=> readStartAddress,
        BUFFER_SIZE => bufferSize,
        DOWN_SAMPLING => downSampling,
        STATE => state
    );
    

    CLOCK_PRESCALER_1 : ClockPrescaler PORT MAP(Clock100MHz => clock100Mhz,
                                                Reset => '0',
                                                Clock1Hz => clock1Hz);
               

end architecture STRUCTURE;
