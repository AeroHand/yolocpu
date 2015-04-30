module mp3_tb;

timeunit 1ns;
timeprecision 1ns;

logic clk;

logic pmem_read;
logic pmem_write;
logic [15:0] pmem_address;
logic [127:0] pmem_wdata;
logic pmem_resp;
logic [127:0] pmem_rdata;

/* Clock generator */
initial clk = 0;
always #5 clk = ~clk;

mp3 dut
(
    .clk,
    .pmem_rdata(pmem_rdata),
    .pmem_resp(pmem_resp),
    .pmem_addr(pmem_address),
    .pmem_wdata(pmem_wdata),
    .pmem_read(pmem_read),
    .pmem_write(pmem_write)
);

physical_memory DRAM
(
    .clk,
    .read(pmem_read),
    .write(pmem_write),
    .address(pmem_address),
    .wdata(pmem_wdata),
    .resp(pmem_resp),
    .rdata(pmem_rdata)
);

endmodule : mp3_tb