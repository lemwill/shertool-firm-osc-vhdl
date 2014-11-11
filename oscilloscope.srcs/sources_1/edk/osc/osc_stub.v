//-----------------------------------------------------------------------------
// osc_stub.v
//-----------------------------------------------------------------------------

module osc_stub
  (
    RS232_Uart_1_sout,
    RS232_Uart_1_sin,
    RESET,
    CLK,
    axi_gpio_0_GPIO_IO_pin,
    axi_iic_0_Gpo_pin,
    SDA,
    SCL,
    SPI_SCLK,
    SPI_MISO,
    SPI_MOSI,
    SPI_SS,
    axi_spi_pga_SPISEL_pin,
    axi_spi_pga_SCK_pin,
    axi_spi_pga_MISO_pin,
    axi_spi_pga_MOSI_pin,
    axi_spi_pga_SS_pin,
    phytxclk,
    phyrxclk,
    phycrs,
    phyrxdv,
    phyRXD,
    phycol,
    phyrxer,
    phyrst,
    phytxen,
    phyTXD,
    phymdc,
    phymdi,
    axi_ethernetlite_0_IP2INTC_Irpt_pin
  );
  output RS232_Uart_1_sout;
  input RS232_Uart_1_sin;
  input RESET;
  input CLK;
  inout [2:0] axi_gpio_0_GPIO_IO_pin;
  output axi_iic_0_Gpo_pin;
  inout SDA;
  inout SCL;
  inout SPI_SCLK;
  inout SPI_MISO;
  inout SPI_MOSI;
  inout SPI_SS;
  input axi_spi_pga_SPISEL_pin;
  inout axi_spi_pga_SCK_pin;
  inout axi_spi_pga_MISO_pin;
  inout axi_spi_pga_MOSI_pin;
  inout [1:0] axi_spi_pga_SS_pin;
  (* BUFFER_TYPE = "IBUF" *)
  input phytxclk;
  (* BUFFER_TYPE = "IBUF" *)
  input phyrxclk;
  input phycrs;
  input phyrxdv;
  input [3:0] phyRXD;
  input phycol;
  input phyrxer;
  output phyrst;
  output phytxen;
  output [3:0] phyTXD;
  output phymdc;
  inout phymdi;
  output axi_ethernetlite_0_IP2INTC_Irpt_pin;

  (* BOX_TYPE = "user_black_box" *)
  osc
    osc_i (
      .RS232_Uart_1_sout ( RS232_Uart_1_sout ),
      .RS232_Uart_1_sin ( RS232_Uart_1_sin ),
      .RESET ( RESET ),
      .CLK ( CLK ),
      .axi_gpio_0_GPIO_IO_pin ( axi_gpio_0_GPIO_IO_pin ),
      .axi_iic_0_Gpo_pin ( axi_iic_0_Gpo_pin ),
      .SDA ( SDA ),
      .SCL ( SCL ),
      .SPI_SCLK ( SPI_SCLK ),
      .SPI_MISO ( SPI_MISO ),
      .SPI_MOSI ( SPI_MOSI ),
      .SPI_SS ( SPI_SS ),
      .axi_spi_pga_SPISEL_pin ( axi_spi_pga_SPISEL_pin ),
      .axi_spi_pga_SCK_pin ( axi_spi_pga_SCK_pin ),
      .axi_spi_pga_MISO_pin ( axi_spi_pga_MISO_pin ),
      .axi_spi_pga_MOSI_pin ( axi_spi_pga_MOSI_pin ),
      .axi_spi_pga_SS_pin ( axi_spi_pga_SS_pin ),
      .phytxclk ( phytxclk ),
      .phyrxclk ( phyrxclk ),
      .phycrs ( phycrs ),
      .phyrxdv ( phyrxdv ),
      .phyRXD ( phyRXD ),
      .phycol ( phycol ),
      .phyrxer ( phyrxer ),
      .phyrst ( phyrst ),
      .phytxen ( phytxen ),
      .phyTXD ( phyTXD ),
      .phymdc ( phymdc ),
      .phymdi ( phymdi ),
      .axi_ethernetlite_0_IP2INTC_Irpt_pin ( axi_ethernetlite_0_IP2INTC_Irpt_pin )
    );

endmodule

