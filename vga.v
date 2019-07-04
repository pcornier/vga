
// 640x480 = 800x524 = 419200 pixels
// 419200 x 60 f/s = 25 152 000 px/s = ~25mhz
//
//    | video | front porch | sync pulse | back porch |
// ---+-------+-------------+------------+------------|
// hz |   640 |          16 |         96 |         48 | = 800
// ---+-------+-------------+------------+------------|
// vt |   480 |          11 |          2 |         31 | = 524
// ---+-------+-------------+------------+------------|
//
// hz events: V:[0]-639 FP:[640]-655 SP:[656]-751 BP:[752]-800
// vt events: V:[0]-479 FP:[480]-490 SP:[491]-492 BP:[493]-524

module vga(
  input CLK_50M,
  output wire h_sync,
  output wire v_sync,
  output [9:0] xpos,
  output [9:0] ypos
);

reg [9:0] h_count;
reg [9:0] v_count;

// 25M clock
reg CLK_25M;
initial CLK_25M = 1'b0;
always @(posedge CLK_50M)
  CLK_25M <= ~CLK_25M;

parameter
  HFP = 640,
  VFP = 480,
  HSP = 656,
  VSP = 491,
  HBP = 752,
  VBP = 493,
  HPX = 800,
  VPX = 527;

assign h_sync = ~((h_count >= HSP) && (h_count < HBP));
assign v_sync = ~((v_count >= VSP) && (v_count < VBP));
assign xpos = h_count < HFP ? h_count : 10'b0;
assign ypos = v_count < VFP ? v_count : 10'b0;

always @(posedge CLK_50M) begin
  if (CLK_25M) begin
    if (h_count == HPX) begin
      h_count <= 0;
      v_count <= v_count + 1;
    end
    else
      h_count <= h_count + 1;
    if (v_count == VPX)
      v_count <= 0;
  end
end

endmodule
