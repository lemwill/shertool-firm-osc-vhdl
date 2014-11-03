-------------------------------------------------------------------------------
-- osc_stub.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity osc_stub is
  port (
    RS232_Uart_1_sout : out std_logic;
    RS232_Uart_1_sin : in std_logic;
    RESET : in std_logic;
    CLK : in std_logic;
    axi_gpio_0_GPIO_IO_pin : inout std_logic_vector(2 downto 0)
  );
end osc_stub;

architecture STRUCTURE of osc_stub is

  component osc is
    port (
      RS232_Uart_1_sout : out std_logic;
      RS232_Uart_1_sin : in std_logic;
      RESET : in std_logic;
      CLK : in std_logic;
      axi_gpio_0_GPIO_IO_pin : inout std_logic_vector(2 downto 0)
    );
  end component;

 attribute BOX_TYPE : STRING;
 attribute BOX_TYPE of osc : component is "user_black_box";

begin

  osc_i : osc
    port map (
      RS232_Uart_1_sout => RS232_Uart_1_sout,
      RS232_Uart_1_sin => RS232_Uart_1_sin,
      RESET => RESET,
      CLK => CLK,
      axi_gpio_0_GPIO_IO_pin => axi_gpio_0_GPIO_IO_pin
    );

end architecture STRUCTURE;

