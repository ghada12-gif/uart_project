`timescale 1ns / 1ps

module tb_uart;

    reg clk;
    reg rst;
    reg tx_start;
    reg [7:0] tx_data;

    wire tx;
    wire busy;
    wire rx;
    wire [7:0] rx_data;
    wire valid_rx;
    wire stop_error;

    // Loopback connection: tx → rx
    assign rx = tx;

    // Instantiating Top Module
    uart_top uut (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .busy(busy),
        .rx(rx),
        .rx_data(rx_data),
        .valid_rx(valid_rx),
        .stop_error(stop_error)
    );

    // Clock Generation: 50MHz → period = 20ns
    always #10 clk = ~clk;

    reg [7:0] test_data [0:3];
    integer i;

    initial begin
        clk = 0;
        rst = 1;
        tx_data = 8'b00000000;
        tx_start = 0;

        // Test cases
        test_data[0] = 8'b10101010;
        test_data[1] = 8'b11001100;
        test_data[2] = 8'b00001111;
        test_data[3] = 8'b11110000;

        #50;
        rst = 0;

        for (i = 0; i < 4; i = i + 1) begin
            @(negedge clk);
            tx_data = test_data[i];
            tx_start = 1;
            @(negedge clk);
            tx_start = 0;

            // Wait for data to be received
            wait(valid_rx == 1);
            #20;

            if (rx_data == test_data[i] && stop_error == 0) begin
                $display("Test %0d PASSED! Sent = %b, Received = %b", i, test_data[i], rx_data);
            end else begin
                $display("Test %0d FAILED! Sent = %b, Received = %b, Stop_Error = %b", i, test_data[i], rx_data, stop_error);
            end
        end

        #100;
        $finish;
    end

endmodule
