module memory
(
    input clk,
    input read,
    input write,
    input [1:0] byte_enable,
    input [15:0] address,
    input [15:0] wdata,
    output logic resp,
    output logic [15:0] rdata
);

timeunit 1ns;
timeprecision 1ns;

parameter DELAY_MEM = 200;

logic [7:0] mem [0:2**($bits(address))-1];
logic [15:0] internal_address;
logic ready;

/* Initialize memory contents from memory.lst file */
initial
begin
    $readmemh("memory.lst", mem);
end

assign internal_address = {address[15:1], 1'b0};

enum int unsigned {
    idle,
    busy,
    respond
} state, next_state;

always @(state, read, write, ready)
begin
    /* Default */
    resp = 1'b0;

    next_state = state;

    case(state)
        idle: begin
            if (read | write) begin
                next_state = busy;

                ready <= #DELAY_MEM 1;
            end
        end

        busy: begin
            if (ready == 1) begin
                if (write) begin
                    if (byte_enable[1]) begin
                        mem[internal_address+1] = wdata[15:8];
                    end

                    if (byte_enable[0]) begin
                        mem[internal_address] = wdata[7:0];
                    end
                end

                rdata = {mem[internal_address+1], mem[internal_address]};

                next_state = respond;
            end
        end

        respond: begin
            resp = 1;

            next_state = idle;

            ready <= 0;
        end

        default: next_state = idle;
    endcase
end

always_ff @(posedge clk)
begin : next_state_assignment
    state <= next_state;
end

endmodule : memory