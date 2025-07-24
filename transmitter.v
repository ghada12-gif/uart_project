module uart_tx (
    input wire clk,
    input wire rst,
    input wire tick,
    input wire start,
    input wire [7:0] data,
    output reg tx,
    output reg busy
);

    reg [3:0] bit_index;
    reg [9:0] shift_reg;
    reg sending;

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1'b1;  // idle
            busy <= 0;
            sending <= 0;
            bit_index <= 0;
            shift_reg <= 10'b1111111111;
        end else begin
            if (start && !busy) begin
                shift_reg <= {1'b1, data, 1'b0};  // {Stop, Data, Start}
                busy <= 1;
                sending <= 1;
                bit_index <= 0;
            end else if (tick && sending) begin
                tx <= shift_reg[0];
                shift_reg <= shift_reg >> 1;
                bit_index <= bit_index + 1;

                if (bit_index == 9) begin
                    busy <= 0;
                    sending <= 0;
                end
            end
        end
    end

endmodule