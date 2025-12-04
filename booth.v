module booth (
    input clk, rst, load,
    input signed [7:0] a, b,
    output reg signed[15:0] product,
    output reg done
);

    reg [7:0]M, Q, A;
    reg signed [8:0]M_bar;
    reg Q_1;
    reg [2:0]count;


    reg [2:0]state;
    parameter IDLE = 3'b000,
                LOAD = 3'b001,
                COMPARE = 3'b010,
                ZERO_ONE = 3'b011,
                ONE_ZERO = 3'b100,
                SHIFT = 3'b101,
                DONE = 3'b110;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= IDLE;
            A <= 8'b00;
            M <= 8'b00;
            M_bar <= 9'b00;
            Q <= 8'b00;
            Q_1 <= 1'b0;
            done <= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    done <= 1'b0;
                    if(load)begin
                        state <= LOAD;
                    end
                end
                LOAD: begin
                    count <= 0;
                    A <= 8'b00;
                    M <= a;
                    Q <= b;
                    Q_1 <= 1'b0;
                    M_bar <= (~a) + 1'b1;
                    state <= COMPARE;
                end
                COMPARE: begin
                    if({Q[0],Q_1} == 2'b01) state <= ZERO_ONE;
                    else if({Q[0],Q_1} == 2'b10) state <= ONE_ZERO;
                    else state <= SHIFT;
                end
                ZERO_ONE: begin
                    A <= A + M;
                    state <= SHIFT;
                end
                ONE_ZERO: begin
                    A <= A + M_bar;
                    state <= SHIFT;
                end
                SHIFT: begin
                    {A,Q,Q_1} <= {A[7],A[7:1],A[0],Q[7:1],Q[0]};
                    if(count == 7)state <= DONE;
                    else begin
                        count <= count + 1;
                        state <= COMPARE;
                    end
                end
                DONE: begin
                    product <= {A, Q};
                    done <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end   
endmodule