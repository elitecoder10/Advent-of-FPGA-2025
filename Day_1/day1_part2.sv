module safe_dial (
    input  logic        clk,
    input  logic        rstn,     
    input  logic        dirn,     
    input  logic [9:0]  dis,
    output logic [31:0] password
);

logic [3:0]	  dis_quo;
logic [31:0]  counter;
logic [6:0]   dis_mod;
logic [6:0]   position;
logic [7:0]   next_pos;

assign dis_quo = dis / 7'd100;
assign dis_mod = dis % 7'd100;

// COMBINATIONAL LOGIC for Counter
always_comb begin
	 if (!dirn) begin
    	counter = (dis >= 10'd100 ? dis_quo : 0) + (position!=0 && position <= dis_mod ? 1 : 0);
    end
    
    else begin
    	counter = (dis >= 10'd100 ? dis_quo : 0) + (position!=0 && (position + dis_mod > 8'd99) ? 1 : 0);
end
end

// COMBINATIONAL LOGIC for next_position
always_comb begin
    if (!dirn) begin
    	next_pos = (position >= dis_mod) ? position - dis_mod :
    			    position - dis_mod + 7'd100;		
    end else begin
        next_pos = (position + dis_mod <= 8'd99) ? position + dis_mod :
			        position + dis_mod - 7'd100;
    end
end

// SEQUENTIAL LOGIC
always_ff @(posedge clk) begin
    if (!rstn) begin
        position <= 7'd50;
        password <= 32'd0;
    end else begin
        position <= next_pos[6:0];
        password <= password + counter;
    end
end

endmodule
