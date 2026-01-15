module advent1_tb;

logic 	clk = 0;
logic 	rstn;
logic 	dirn;
logic [9:0] dis;
logic [31:0] password;

integer fd;
byte 	d;
int 	val;

safe_dial dut (
	.clk(clk),
	.rstn(rstn),
	.dirn(dirn),
	.dis(dis),
	.password(password)
);

always #5 clk = ~clk;

initial begin
	$dumpfile("wave.vcd");
	$dumpvars(0, advent1_tb);
end

initial begin

rstn = 0;
dirn = 0;
dis =  0;

repeat (2) @(posedge clk);

rstn = 1;

  fd = $fopen("input.txt","r");

if (fd == 0) begin
	$fatal(1,"Failed to open");
end

while ($fscanf(fd," %1s%d", d, val) == 2) begin
	dirn = (d == "R");
	dis = val;
	@(posedge clk);
end

$fclose(fd);

@(posedge clk);

$display("Final password = %d",password);
$finish;
end

endmodule
