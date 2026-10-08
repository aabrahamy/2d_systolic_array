/*==============================================================================
* Description: Compute nodes in an N x N grid inside systolic_array.
 *             Output-stationary: every cycle it multiplies a_in by b_in and
 *             adds the product to a local accumulator (acc), which stays in
 *             place, while registering a_in and b_in onto a_out (right
 *             neighbor) and b_out (bottom neighbor). Zero padding from the
 *             skew logic leaves the accumulator unchanged, so no valid signal 
 *             is needed. A synchronous active-high reset clears the accumulator 
 *             and operand registers. DATA_WIDTH is the number of bits in each 
 *             input value (unsigned). ACC_WIDTH is the number of bits in the 
 *             accumulator, and needs to be big enough to hold the sum of N 
 *             products: at least 2*DATA_WIDTH + $clog2(N) bits, or it can overflow.
 *============================================================================*/
module processing_element #(
    parameter int DATA_WIDTH = 8,
    parameter int ACC_WIDTH  = 32
) (
    input  logic clk,
    input  logic rst,

    input  logic [DATA_WIDTH-1:0] a_in, // from left neighbor / row buffer
    input  logic [DATA_WIDTH-1:0] b_in, // from top neighbor / column buffer

    output logic [DATA_WIDTH-1:0] a_out, // to right neighbor
    output logic [DATA_WIDTH-1:0] b_out, // to bottom neighbor

    output logic [ACC_WIDTH-1:0]  acc_out // stationary partial sum / result
);

    always_ff @(posedge clk) begin
        if (rst) begin
            a_out <= '0;
            b_out <= '0;
            acc_out <= '0;
        end else begin
            a_out <= a_in;
            b_out <= b_in;
            acc_out <= acc_out + ACC_WIDTH'(a_in) * ACC_WIDTH'(b_in);
        end
    end

endmodule
