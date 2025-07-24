'timescale 1ns/ 1ps 
module tb_uart ;
     reg clk ;         
     reg rst ;              
     reg tx_start;      
     reg [7:0] tx_data; 
     wire tx ;           
     wire busy;         
     wire rx;
     wire [7:0] rx_data; 
     wire valid_rx;  
     wire stop_error ;

     assign rx =tx ;
     uart_top utt(.clk(clk),
        .rst(rst),.tx_start(tx_start),
        .tx_data(tx_data),.rx(rx),
        .tx(tx),.busy(busy),.valid_rx(valid_rx),
        .stop_error(stop_error),.rx_data(rx_data));
     always #10 clk =~ clk;
     reg [7:0] test_data [3:0];
     integer i;
     

     intial begin 
         clk =0;
         rst=1;
         tx_data = 8'b00000000;
         tx_start = 0;
         test_data[0]=8'b10101010;
         test_data[1]=8'b11001100;
         test_data[2]=8'b00001111;
         test_data[3]=8'b11110000;
         #50;
         rst =0,
         for(i=0; i<4; i=i+1) begin
             @(negedge clk);
             tx_data =test_data[i];
             @(negedge clk);
             tx_data=0;
             


             wait(valid_rx == 1);
             #20;
             if (rx_data ==test_data[i] && stop_error == 0)
                $display ("test %0d passed ! sent %b,recived %b ", i,test_data[i],rx_data);

             else
                $display ("test %0d failed ! sent %b,recived %b ,stop_error: %b ", i,test_data[i],rx_data,stop_error);


     end
     #100;
     $finish;


endmodule