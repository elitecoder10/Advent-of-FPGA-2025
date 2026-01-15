module safe_dial (
    input  logic        clk,
    input  logic        rstn,     
    input  logic        dirn,     
    input  logic [9:0]  dis,
    output logic [31:0] password
);

logic [6:0] dis_mod;
logic [6:0] position;
logic [7:0] next_pos;

assign dis_mod = dis % 7'd100;

// COMBINATIONAL LOGIC
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
        
        if (next_pos[6:0] == 7'b0) begin
           password <= password + 1;
        end
    end
end

endmodule
