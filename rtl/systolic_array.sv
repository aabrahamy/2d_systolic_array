/*=============================================================================
 * Module:      systolic_array
 * Parameter:   N : grid dimension (N x N processing elements)
 *
 * Description: Output-stationary systolic array for matrix multiplication
 *              (C = A x B). Instantiates an N x N grid of processing_elements
 *              via a parametrized generate block.
 *
 *              Row buffers, one per row of matrix A, and column buffers, one per
 *              column of matrix B, each receive a full row/column of input data in
 *              a single cycle. After loading, each buffer waits for a
 *              delay equal to its row/column index before draining its values 
 *              one per cycle toward the array. This staggered timing ensures that
 *              A[i][k] and B[k][j] arrive at PE(i,j) on the same cycle.
 *
 *              Each PE multiplies its incoming row/column operands every
 *              cycle, accumulates the result into a partial sum, and 
 *              forwards both operands to its right and bottom neighbors.
 *              Partial sums remain stationary at their PE for the duration
 *              of the computation. The only moving components are the operands.
 *
 *              Once all operands have propagated through the array and
 *              accumulation is complete, each PE holds the final value of
 *              its corresponding output element, read out as the final
 *              output matrix!
 *===========================================================================*/