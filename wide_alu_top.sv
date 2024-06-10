module wide_alu_top #(
    parameter   int unsigned AXI_ADDR_WIDTH = 32,
    localparam  int unsigned AXI_DATA_WIDTH = 32,
    parameter   int unsigned AXI_ID_WIDTH   = -1,
    parameter   int unsigned AXI_USER_WIDTH = -1
)(
    input wire clk_i,
    input wire rst_ni,
    input wire test_mode_i,

    // AXI Slave Interface
    AXI_BUS.Slave axi_slave
);

    // Internal signals
    logic [255:0] data_in, data_out;
    logic [AXI_ADDR_WIDTH-1:0] axi_addr;
    logic axi_write, axi_read;
    logic axi_valid, axi_ready;

    // Instantiate wide_alu IP
    wide_alu u_wide_alu (
      .clk_i(),
      .rst_ni(),
      .trigger_i(),
      .clear_err_i(),
      .op_a_i(),
      .op_b_i(),
      .result_o(),
      .deaccel_factor_we_i(),
      .deaccel_factor_i(),
      .deaccel_factor_o(),
      .op_sel_we_i(),
      .op_sel_i(),
      .op_sel_o(),
      .status_o()  
    );

    // AXI Slave Interface Logic
    // This logic will handle the AXI transactions and communicate with the wide_alu IP

    // AXI Write Operation
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            axi_ready <= 1'b0;
            // Reset signals
        end else begin
            if (axi_slave.awvalid && !axi_ready) begin
                axi_addr <= axi_slave.awaddr;
                axi_ready <= 1'b1;
            end
            if (axi_slave.wvalid && axi_ready) begin
                data_in <= axi_slave.wdata;
                axi_write <= 1'b1;
            end else begin
                axi_write <= 1'b0;
            end
            if (axi_slave.bready && axi_write) begin
                axi_ready <= 1'b0;
            end
        end
    end

    // AXI Read Operation
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            axi_ready <= 1'b0;
            // Reset signals
        end else begin
            if (axi_slave.arvalid && !axi_ready) begin
                axi_addr <= axi_slave.araddr;
                axi_ready <= 1'b1;
            end
            if (axi_ready) begin
                data_out <= u_wide_alu.data_out;
                axi_read <= 1'b1;
            end else begin
                axi_read <= 1'b0;
            end
            if (axi_slave.rready && axi_read) begin
                axi_ready <= 1'b0;
            end
        end
    end

    // AXI Slave Response
    assign axi_slave.awready = axi_ready;
    assign axi_slave.wready = axi_ready;
    assign axi_slave.bresp = 2'b00; // OKAY response
    assign axi_slave.bvalid = axi_write;
    assign axi_slave.arready = axi_ready;
    assign axi_slave.rdata = data_out;
    assign axi_slave.rresp = 2'b00; // OKAY response
    assign axi_slave.rvalid = axi_read;

endmodule

