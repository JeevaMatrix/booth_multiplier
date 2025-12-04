`timescale 1ps/1ps
`include "booth.v"

module booth_tb();
    reg clk, rst, load;
    reg signed [7:0]a, b;

    wire signed [15:0]product;
    wire done;

    booth DUT(.clk(clk), .rst(rst), .load(load), .a(a), .b(b), .product(product), .done(done));

    initial begin
        clk = 0; rst = 1; load = 0;
        #5 rst = 0;

        a=10; b=-2;
        load = 1; #10 load = 0;
        wait(done); 
        #10
        a=-8; b=4; 
        load = 1; #10 load = 0;
        wait(done); 
        #10
        a=-5; b=-2;
        load = 1; #10 load = 0;
        wait(done);
        #10
        a=3; b=7;
        load = 1; #10 load = 0;
        wait(done);

        #100
        $finish;
    end

    initial begin
        $dumpfile("booth.vcd");
        $dumpvars(0,booth_tb);

        // $monitor("clk=%d  A=%d  B=%d  Product=%d",clk, a, b, product);
    end
    always @(posedge done) begin
        $display("✅ DONE: A=%d  B=%d  Product=%d", a, b, product);
    end
    always #5 clk = ~clk; //10 - time period

endmodule