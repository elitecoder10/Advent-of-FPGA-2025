module advent2_tb;

logic [63:0] id;
logic clk = 0;
logic resetn;
logic [63:0] invalid_sum;

integer fd;

longint ID;
longint id_start;
longint id_end;

gift_shop dut (
.id(id),
.clk(clk),
.resetn(resetn),
.invalid_sum(invalid_sum)
);

always #5 clk = ~clk;

initial begin
$dumpfile("wave2.vcd");
$dumpvars(0, advent2_tb);
end

initial begin
id = 0;
resetn = 0;

repeat (2) @(posedge clk);

resetn = 1;

fd = $fopen("IDs.txt", "r");

if (fd == 0) begin
$fatal(1, "Failed to open");
end

while ($fscanf(fd,"%d-%d,",id_start,id_end) == 2 || $fscanf(fd,"%d-%d",id_start,id_end) == 2) begin
for(ID = id_start; ID <= id_end; ID++) begin
    @(negedge clk);
    id = ID;
end
end
$fclose(fd);

repeat (4) @(posedge clk);
$display("Invalid ID sum = %d", invalid_sum);
$finish;
end
endmodule
