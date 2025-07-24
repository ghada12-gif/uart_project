module baud_rate_generator (
    input wire clk,
    input wire rst,         
    output reg tick
);
    parameter N = 5208;
    reg [12:0] counter;

    always @(posedge clk or posedge rst) begin  
        if (rst) begin
            counter <= 0;
            tick <= 0;
        end else begin
            if (counter == N-1) begin
                tick <= 1;
                counter <= 0;
            end else begin
                tick <= 0;
                counter <= counter + 1;  
            end
        end
    end

endmodule
