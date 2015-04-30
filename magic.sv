import lc3b_types::*;

module magic 
(
	input clk,
    input read,
    input write,
    input [15:0] address,
    input [127:0] wdata,
    output logic resp,
    output logic [127:0] rdata
);

timeunit 1ns;
timeprecision 1ns;

logic [127:0] mem [0:2**($bits(address)-4)-1];
logic [11:0] internal_address;

initial
begin
    $readmemh("memory.lst", mem);
end

assign internal_address = address[15:4];

always @(posedge read)
begin : mem_read
    rdata = mem[internal_address];
end : mem_read

always @(posedge write)
begin : mem_write
    mem[internal_address] = wdata;
end : mem_write

assign resp = read | write;

endmodule : magic