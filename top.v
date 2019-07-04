
module top(

  input clk,

  output [4:0] red,
  output [5:0] green,
  output [4:0] blue,
  output h_sync,
  output v_sync

);

wire [9:0] xpos;
wire [9:0] ypos;

// three small boxes on the screen
assign red = xpos > 50 && xpos < 90 && ypos > 50 && ypos < 90 ? 5'b11111 : 5'b0;
assign green = xpos > 65 && xpos < 105 && ypos > 65 && ypos < 105 ? 6'b111111 : 6'b0;
assign blue = xpos > 80 && xpos < 120 && ypos > 80 && ypos < 120 ? 5'b11111 : 5'b0;

vga display(
  .CLK_50M(clk),
  .h_sync(h_sync),
  .v_sync(v_sync),
  .xpos(xpos),
  .ypos(ypos)
);

endmodule
