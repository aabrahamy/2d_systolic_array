// testbench for processing element MAC unit
module tb_processing_element;
    // parameters
    parameter int DATA_WIDTH = 8;
    parameter int ACC_WIDTH  = 32;

    // internal signals
    logic clk;
    logic rst;

    logic [DATA_WIDTH-1:0] a_in;
    logic [DATA_WIDTH-1:0] b_in;

    logic [DATA_WIDTH-1:0] a_out;
    logic [DATA_WIDTH-1:0] b_out;

    logic [ACC_WIDTH-1:0] acc_out;

    // DUT instantiation
    processing_element #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .a_in(a_in),
        .b_in(b_in),
        .a_out(a_out),
        .b_out(b_out),
        .acc_out(acc_out)
    );

    always #5 clk = ~clk;

    int errors = 0;

    // compare a value against the expected one
    task automatic check(input string name, input int actual, input int expected);
        if (actual !== expected) begin
            $display("FAIL: %s = %0d, expected %0d", name, actual, expected);
            errors++;
        end else begin
            $display("PASS: %s = %0d", name, actual);
        end
    endtask

    initial begin
        clk = 0;
        rst = 1;
        a_in = 0;
        b_in = 0;

        // reset for two clock edges
        repeat (2) @(posedge clk);
        #1 rst = 0;
        check("acc after reset", acc_out, 0);

        // 3 * 4 = 12
        a_in = 3; b_in = 4;
        @(posedge clk); #1;
        check("acc after 3*4", acc_out, 12);
        check("a_out", a_out, 3);
        check("b_out", b_out, 4);

        // accumulate 2 * 5 = 10 -> 22
        a_in = 2; b_in = 5;
        @(posedge clk); #1;
        check("acc after +2*5", acc_out, 22);

        // zero padding leaves the accumulator unchanged
        a_in = 0; b_in = 0;
        @(posedge clk); #1;
        check("acc after zeros", acc_out, 22);

        // reset clears everything
        rst = 1;
        @(posedge clk); #1;
        check("acc after reset", acc_out, 0);

        if (errors == 0) $display("ALL TESTS PASSED");
        else $display("%0d TESTS FAILED", errors);
        $finish;
    end
endmodule
