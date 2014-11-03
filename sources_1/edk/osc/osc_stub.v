//-----------------------------------------------------------------------------
// osc_stub.v
//-----------------------------------------------------------------------------

module osc_stub
  (
    RS232_Uart_1_sout,
    RS232_Uart_1_sin,
    RESET,
    CLK
  );
  output RS232_Uart_1_sout;
  input RS232_Uart_1_sin;
  input RESET;
  input CLK;

  (* BOX_TYPE = "user_black_box" *)
  osc
    osc_i (
      .RS232_Uart_1_sout ( RS232_Uart_1_sout ),
      .RS232_Uart_1_sin ( RS232_Uart_1_sin ),
      .RESET ( RESET ),
      .CLK ( CLK )
    );

endmodule

