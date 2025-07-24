module uart_rx (
    input wire clk,
    input wire rst,
    input wire rx,          
    input wire tick,        
    output reg [7:0] data_out,
    output reg valid_rx,    
    output reg stop_error   
);

    reg [3:0] sample_count;   
    reg [3:0] bit_index;      
    reg [7:0] data_buf;       
    reg [1:0] state;

    localparam IDLE = 2'b00;
    localparam START = 2'b01;
    localparam DATA = 2'b10;
    localparam STOP = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            sample_count <= 0;
            bit_index <= 0;
            data_buf <= 0;
            data_out <= 0;
            valid_rx <= 0;
            stop_error <= 0;
        end else if (tick) begin
            case (state)
                IDLE: begin
                    valid_rx <= 0;
                    stop_error <= 0;
                    if (rx == 0) begin  
                        state <= START;
                        sample_count <= 0;
                    end
                end

                START: begin
                    if (sample_count == 7) begin 
                        if (rx == 0) begin
                            sample_count <= 0;
                            bit_index <= 0;
                            state <= DATA;
                        end else begin
                            state <= IDLE;  
                        end
                    end else begin
                        sample_count <= sample_count + 1;
                    end
                end

                DATA: begin
                    if (sample_count == 15) begin
                        sample_count <= 0;
                        data_buf[bit_index] <= rx;
                        if (bit_index == 7) begin
                            state <= STOP;
                        end else begin
                            bit_index <= bit_index + 1;
                        end
                    end else begin
                        sample_count <= sample_count + 1;
                    end
                end

                STOP: begin
                    if (sample_count == 15) begin
                        if (rx == 1) begin
                            data_out <= data_buf;
                            valid_rx <= 1;
                            stop_error <= 0;
                        end else begin
                            stop_error <= 1;
                        end
                        state <= IDLE;
                        sample_count <= 0;
                    end else begin
                        sample_count <= sample_count + 1;
                    end
                end
            endcase
        end
    end

endmodule

