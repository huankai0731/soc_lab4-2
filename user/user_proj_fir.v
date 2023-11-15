// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0


`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */

module user_proj_fir #(
    parameter BITS = 32,
    parameter DELAYS=10
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o

  // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // IRQ
    output [2:0] irq

);
  

    wire clk;
    wire rst;
    assign rst = wb_rst_i;
    assign clk = wb_clk_i;

  
    wire [31:0] rdata; 
    wire [31:0] wdata;
    //wire [BITS-1:0] count;

    wire valid;
    wire [3:0] wstrb;
    //wire [31:0] la_write;



    //reg [BITS-17:0] delayed_count;

    // WB MI A
    assign valid = wbs_cyc_i && wbs_stb_i && decoded; 
    assign wstrb = wbs_sel_i & {4{wbs_we_i}};
    assign wbs_dat_o = rdata;
    assign wdata = wbs_dat_i;

    //assign wbs_ack_o = rr;
    //reg rr;
    //reg ready;

    


    //Axi lite
    assign awvalid = valid && wbs_we_i && tap;
    assign wvalid = valid && wbs_we_i && tap;
    
    wire awvalid;
    wire wvalid;


    reg [31:0]awaddr;
    reg tap = 0;
    assign decoded = wbs_adr_i[31:8] == 24'h300000 ? 1'b1 : 1'b0;
    wire decoded;
    //assign wbs_ack_o = ready;
    //reg ready=1;

    always @(posedge clk) begin
    $display("%x %d ready:%d",wbs_adr_i,wbs_dat_i,wbs_ack_o);

        if(decoded) begin
        $display("%x %d valid:%d",awaddr,wbs_dat_i,wvalid);
        case (wbs_adr_i[7:0])
        /*
            //ap_ctr
            2'h00: 
            //data_length
            2'h10: 
            //X[n]
            2'h80:
            //Y[n] 
            2'h84: 
            //tap
            default: tap<=1;
            
*/
            8'h50: $display("%b %u",wbs_adr_i,wbs_dat_i);
            default: begin
                tap<=1;
                awaddr <= {{26{1'b0}},wbs_adr_i[6:5],wbs_adr_i[3:0]};
            end

            
        endcase
        end

    end








    fir fir_DUT(
        .awready(wbs_ack_o),
        .wready(wbs_ack_o),
        .awvalid(awvalid),
        .awaddr(awaddr),
        .wvalid(wvalid),
        .wdata(wdata),
        
        .axis_clk(clk),
        .axis_rst_n(rst),      
        
        
        .arready(arready),
        .rready(rready),
        .arvalid(arvalid),
        .araddr(araddr),
        .rvalid(rvalid),
        .rdata(rdata),

        .ss_tvalid(ss_tvalid),
        .ss_tdata(ss_tdata),
        .ss_tlast(ss_tlast),
        .ss_tready(ss_tready),
        .sm_tready(sm_tready),
        .sm_tvalid(sm_tvalid),
        .sm_tdata(sm_tdata),
        .sm_tlast(sm_tlast),

        // ram for tap
        .tap_WE(tap_WE),
        .tap_EN(tap_EN),
        .tap_Di(tap_Di),
        .tap_A(tap_A),
        .tap_Do(tap_Do),

        // ram for data
        .data_WE(data_WE),
        .data_EN(data_EN),
        .data_Di(data_Di),
        .data_A(data_A),
        .data_Do(data_Do),



        );
        // RAM for tap
    bram11 tap_RAM (
        .CLK(axis_clk),
        .WE(tap_WE),
        .EN(tap_EN),
        .Di(tap_Di),
        .A(tap_A),
        .Do(tap_Do)
    );

    // RAM for data: choose bram11 or bram12
    bram11 data_RAM(
        .CLK(axis_clk),
        .WE(data_WE),
        .EN(data_EN),
        .Di(data_Di),
        .A(data_A),
        .Do(data_Do)
    );




endmodule


