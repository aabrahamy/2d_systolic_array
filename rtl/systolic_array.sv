/*=============================================================================
 * Description: Output-stationary systolic array for matrix multiplication
 *              (C = A x B). Instantiates an N x N grid of processing_elements
 *              via a parametrized generate block. Each cycle, one column of A
 *              and one row of B enter the array, passing through shift-register
 *              delay chains first: row i of A and column j of B are delayed i
 *              and j cycles, so A[i][k] and B[k][j] reach PE(i,j) on the same
 *              cycle. Each PE multiplies its operands, adds the product to a
 *              local partial sum, and forwards the operands to its right and
 *              bottom neighbors. Partial sums stay in place, so the operands
 *              are the only values that move. Once all operands have passed
 *              through, each PE holds its final output element C[i][j].
 *============================================================================*/
 module systolic_array #(
    parameter int DATA_WIDTH = 8,
    parameter int ACC_WIDTH = 32,
    parameter int N = 3 // matrix dimensions (N x N)
 ) (
    input logic clk,
    input logic rst,
 )
