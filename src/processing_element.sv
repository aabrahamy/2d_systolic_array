/*==============================================================================
 * Module:      processing_element (pe)
 *
 * Description: Individual compute node tiled across the systolic array.
 *              Each instance:
 *                - holds a multiply-accumulate (MAC) unit
 *                - has registers to pass operands to neighboring PEs
 *                - accumulates a partial sum for its position on the grid
 *              Instantiated within systolic_array in an N x N grid.
 *
 * Parameters:  DATA_WIDTH : operand width (unsigned)
 *              ACC_WIDTH  : accumulator width (unsigned); should be at least
 *                           2*DATA_WIDTH + $clog2(N) to avoid overflow
 *
 * Behavior:    Output-stationary. Every cycle:
 *                acc   <= acc + a_in * b_in
 *                a_out <= a_in   (to right neighbor)
 *                b_out <= b_in   (to bottom neighbor)
 *              Padding zeros from the skew logic make the MAC a no-op, so no
 *              valid signal is needed. Synchronous active-high reset clears
 *              the accumulator and operand registers.
 *============================================================================*/

module processing_element #(
    parameter int DATA_WIDTH = 8,
    parameter int ACC_WIDTH  = 32
) (
    input  logic                         clk,
    input  logic                         rst,

    input  logic [DATA_WIDTH-1:0] a_in,    // from left neighbor / row buffer
    input  logic [DATA_WIDTH-1:0] b_in,    // from top neighbor / column buffer

    output logic [DATA_WIDTH-1:0] a_out,   // to right neighbor
    output logic [DATA_WIDTH-1:0] b_out,   // to bottom neighbor

    output logic [ACC_WIDTH-1:0]  acc_out  // stationary partial sum / result
);

    always_ff @(posedge clk) begin
        if (rst) begin
            a_out   <= '0;
            b_out   <= '0;
            acc_out <= '0;
        end else begin
            a_out   <= a_in;
            b_out   <= b_in;
            acc_out <= acc_out + ACC_WIDTH'(a_in) * ACC_WIDTH'(b_in);
        end
    end

endmodule
