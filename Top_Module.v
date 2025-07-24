module uart_top (
    input wire clk,           
    input wire rst,           
    input wire rx,            
    input wire tx_start,      
    input wire [7:0] tx_data, 
    output wire tx,           
    output wire busy,         

    output wire [7:0] rx_data, 
    output wire valid_rx,      
    output wire stop_error     
);

    wire tick;

    // 1 Baud Rate Generator
    baud_rate_generator #( .N(5208) ) brg (
        .clk(clk),
        .rst(rst),
        .tick(tick)
    );

    // 2? Transmitter
    uart_tx tx_unit (
        .clk(clk),
        .rst(rst),
        .tick(tick),
        .start(tx_start),
        .data(tx_data),
        .tx(tx),
        .busy(busy)
    );

    // 3? Receiver
    uart_rx rx_unit (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .tick(tick),
        .data_out(rx_data),
        .valid_rx(valid_rx),
        .stop_error(stop_error)
    );

endmodule

