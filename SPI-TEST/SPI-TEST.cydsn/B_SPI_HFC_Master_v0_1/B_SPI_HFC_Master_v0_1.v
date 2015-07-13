/*******************************************************************************
* File Name:  B_SPI_HFC_Master_v0_1.v
* Version `$CY_MAJOR_VERSION`.`$CY_MINOR_VERSION`
*
* Description:
*  This file provides a base level model of the SPI Master component
*
* Note:
*  None
********************************************************************************
*                 Control and Status Register definitions
********************************************************************************
*
*  Tx interrupt Status Register Definition
*  +=======+--------+--------+--------+--------+--------+--------+--------+--------+
*  |  Bit  |   7    |   6    |   5    |   4    |   3    |   2    |   1    |   0    |
*  +=======+--------+--------+--------+--------+--------+--------+--------+--------+
*  | Desc |interrupt|unused  |unused  |spi_idle|bt_cpmlt|tx_f_n_f|tx_f_emp|spi_done|
*  +=======+--------+--------+--------+--------+--------+--------+--------+--------+
*
*  Rx interrupt Status Register Definition
*  +=======+--------+--------+--------+--------+--------+--------+--------+--------+
*  |  Bit  |   7    |   6    |   5    |   4    |   3    |   2    |   1    |   0    |
*  +=======+--------+--------+--------+--------+--------+--------+--------+--------+
*  | Desc |interrupt|rx_overr|rx_n_emp|rx_full |unused  | unused |unused  | unused |
*  +=======+--------+--------+--------+--------+--------+--------+--------+--------+
*
*    spi_done   =>  0 = spi transmission not done
*                   1 = spi transmission done
*
*    tx_f_e     =>  0 = TX FIFO not empty
*                   1 = TX FIFO empty
*
*    tx_f_n_f   =>  0 = TX_FIFO full
*                   1 = TX FIFO not full
*
*    rx_f_fll   =>  0 =  RX FIFO not full
*                   1 =  RX FIFO full
*
*    rx_f_n_e   =>  0 = RX FIFO empty
*                   1 = RX FIFO not empty
*
*    rx_f_over  =>  0 = RX FIFO not overrun
*                   1 = RX FIFO overrun
*
*    bt_cmplt   =>  0 = byte transfer is not complete
*                   1 = byte transfer complete
*
********************************************************************************
*                 Data Path register definitions
********************************************************************************
*  INSTANCE NAME:  DatapathName
*  DESCRIPTION:
*  REGISTER USAGE:
*    F0 => TX FIFO buffer
*    F1 => RX FIFO buffer
*    D0 => na
*    D1 => na
*    A0 => SPI Master TX value
*    A1 => SPI Master RX value
*
********************************************************************************
*               I*O Signals:
********************************************************************************
*  IO SIGNALS:
*
*    reset        input     component reset input
*    clock        input     component clock input
*    miso         input     SPI MISO input
*    sclk         output    SPI SCLK output
*    ss           output    SPI SS output
*    tx_enable    output    tx enable output(is used for Bidirectional Mode only)
*    mosi         output    SPI MOSI output
*    interrupt    output    interrupt output
*
********************************************************************************
* Copyright 2008-2015, Cypress Semiconductor Corporation.  All rights reserved.
* You may use this file only in accordance with the license, terms, conditions,
* disclaimers, and limitations in the end user license agreement accompanying
* the software package with which this file was provided.
********************************************************************************/

`include "cypress.v"
`ifdef B_SPI_HFC_Master_v0_1__V_ALREADY_INCLUDED
`else
`define B_SPI_HFC_Master_v0_1__V_ALREADY_INCLUDED

module B_SPI_HFC_Master_v0_1(
	input    wire reset,      /* System Reset                               */
	input    wire clock,      /* User Supplied clock = 2x bitrate of output */
	input    wire miso,       /* SPI MISO input                             */
	input    wire rde,        /* RX Data effective                          */

	output   reg  mosi,       /* SPI MOSI output              */
	output   reg  tde,        /* TX Data effective            */
	output   reg  sclk,       /* SPI SCLK output              */
	output   reg  ss,         /* SPI SS output                */
	output   wire tx_interpt, /* Interrupt output             */
	output   wire rx_interpt, /* Interrupt output             */
	output   wire rx_drq,     /* RX DMA request               */
	output   wire tx_drq      /* TX DMA request               */
);
	localparam SPIM_MSB_FIRST = 1'b0;
	localparam SPIM_LSB_FIRST = 1'b1;

	parameter [0:0] ShiftDir         = SPIM_MSB_FIRST;
	parameter [6:0] NumberOfDataBits = 7'd8; /* set to 2-16 bits only. Default is 8 bits */
	parameter [0:0] HighSpeedMode    = 1'b0;
	parameter [0:0] ModeCPHA         = 1'b0; /* Default is rising edge mode */
	parameter [0:0] ModePOL          = 1'b0; /* Default is rising edge mode */

	wire clk_fin;
	cy_psoc3_udb_clock_enable_v1_0 #(.sync_mode(`TRUE))
	ClkEn (
		.clock_in(clock),
		.enable(1'b1),
		.clock_out(clk_fin)
	);

	localparam [6:0] BitCntPeriod = (NumberOfDataBits << 1) - 1;
	wire [6:0] count;
	reg cnt_enable;
	cy_psoc3_count7 #(.cy_period(BitCntPeriod), .cy_route_ld(0), .cy_route_en(1))
	BitCounter(
		/* input          */ .clock(clk_fin),
		/* input          */ .reset(reset),
		/* input          */ .load(1'b0),
		/* input          */ .enable(cnt_enable),
		/* output [06:00] */ .count(count),
		/* output         */ .tc()
	);

	wire dpcounter_one = (count[4:0] == 5'h1);
	reg dpcounter_one_reg;

	wire mosi_from_dp;
	reg mosi_from_dp_reg;

	wire dpMOSI_fifo_not_full;
	wire dpMOSI_fifo_empty;
	wire dpMISO_fifo_not_empty;
	wire dpMISO_fifo_full;

	reg rde_reg;
	reg dpMOSI_fifo_empty_reg;
	generate
	if (HighSpeedMode) begin
		always @(posedge clk_fin) begin
			dpcounter_one_reg <= dpcounter_one;
			mosi_from_dp_reg  <= mosi_from_dp;
		end
	end
	endgenerate

	wire load_rx_data = ((HighSpeedMode == 1 && ModeCPHA == 1) ? dpcounter_one_reg : dpcounter_one) & ~rde_reg;
	reg ld_ident;
	reg is_spi_done;

	/* State Machine state names */
	localparam SPIM_STATE_IDLE              = 3'h0;
	localparam SPIM_STATE_LOAD_TX_DATA      = 3'h1;
	localparam SPIM_STATE_SEND_TX_DATA      = 3'h2;
	localparam SPIM_STATE_CAPT_RX_DATA      = 3'h3;
	localparam SPIM_STATE_SHFT_N_LD_TX_DATA = 3'h4;
	localparam SPIM_STATE_SPI_DONE          = 3'h5;
	localparam SPIM_STATE_WAIT              = 3'h6;
	localparam SPIM_STATE_SEND_TX_DATA_2    = 3'h7;
	reg [2:0] state;


	wire rde_fin;
	cy_psoc3_sync sync_1(
		.sc_out(rde_fin),
		.sc_in(rde),
		.clock(clk_fin)
	);

	generate
	if (ModeCPHA == 1 && HighSpeedMode) begin
		/* State Logic */
		always @(posedge clk_fin) begin
			if (reset) begin
				rde_reg <= 1'b1;
				state <= SPIM_STATE_IDLE;
			end
			else begin
				case (state)
				SPIM_STATE_IDLE: begin
					ss         <= 1'b1;
					cnt_enable <= 1'b0;
					sclk       <= ModePOL;
					tde        <= dpMOSI_fifo_empty;
					rde_reg    <= rde_fin;
					state      <= (dpMOSI_fifo_empty) ? SPIM_STATE_IDLE : SPIM_STATE_LOAD_TX_DATA;
				end

				SPIM_STATE_LOAD_TX_DATA: begin// 15
					cnt_enable <= 1'b1;
					ss         <= 1'b0;
					state      <= SPIM_STATE_WAIT;
				end

				SPIM_STATE_WAIT: begin // 14
					mosi  <= mosi_from_dp;
					sclk  <= ~ModePOL;
					state <= SPIM_STATE_SEND_TX_DATA;
				end

				SPIM_STATE_SEND_TX_DATA: begin // 13
					sclk    <= ModePOL;
					rde_reg <= rde_fin;
					if (dpcounter_one && is_spi_done) begin
						cnt_enable <= 1'b0;
						state      <= SPIM_STATE_SPI_DONE;
					end
					else begin
						state <= SPIM_STATE_CAPT_RX_DATA;
					end
				end

				SPIM_STATE_CAPT_RX_DATA: begin // 12
					mosi <= mosi_from_dp_reg;
					sclk <= ~ModePOL;

					if (count[4:0] != 5'h4) begin
						if (count[4:0] == 5'h0) begin
							tde <= dpMOSI_fifo_empty_reg;
						end
						state <= SPIM_STATE_SEND_TX_DATA;
					end
					else if (dpMOSI_fifo_empty && rde_reg) begin
						is_spi_done <= 1'b1;
						state       <= SPIM_STATE_SEND_TX_DATA;
					end
					else begin
						dpMOSI_fifo_empty_reg <= dpMOSI_fifo_empty;
						state <= SPIM_STATE_SHFT_N_LD_TX_DATA;
					end
				end

				SPIM_STATE_SHFT_N_LD_TX_DATA: begin
					sclk  <= ModePOL;
					state <= SPIM_STATE_CAPT_RX_DATA;
				end

				SPIM_STATE_SPI_DONE: begin
					cnt_enable  <= 1'b0;
					sclk        <= ModePOL;
					is_spi_done <= 1'b0;
					state       <= SPIM_STATE_IDLE;
				end

				default: begin
					ss         <= 1'b1;
					cnt_enable <= 1'b0;
					sclk       <= ModePOL;
					state      <= SPIM_STATE_IDLE;
				end
				endcase
			end
		end
	end

	else if (ModeCPHA == 1 && !HighSpeedMode) begin
		always @(posedge clk_fin) begin
			if (reset) begin
				state <= SPIM_STATE_IDLE;
			end
			else begin
				case (state)
				SPIM_STATE_IDLE: begin
					ss         <= 1'b1;
					cnt_enable <= 1'b0;
					mosi       <= 1'b0;
					sclk       <= ModePOL;
					tde        <= dpMOSI_fifo_empty;
					rde_reg    <= rde;
					state      <= (dpMOSI_fifo_empty && rde_reg) ? SPIM_STATE_IDLE : SPIM_STATE_LOAD_TX_DATA;
				end

				SPIM_STATE_LOAD_TX_DATA: begin // 15
					cnt_enable <= 1'b1;
					ss         <= 1'b0;
					sclk       <= ModePOL;
					state      <= SPIM_STATE_SEND_TX_DATA;
				end

				SPIM_STATE_SEND_TX_DATA: begin // 14
					sclk    <= ~ModePOL;
					mosi    <= mosi_from_dp;
					rde_reg <= rde;
					state   <= (count[4:0] == 5'h2 && !dpMOSI_fifo_empty) ? SPIM_STATE_SHFT_N_LD_TX_DATA : SPIM_STATE_CAPT_RX_DATA;
				end

				SPIM_STATE_CAPT_RX_DATA: begin // 13
					sclk <= ModePOL;
					if (!dpcounter_one) begin
						state <= SPIM_STATE_SEND_TX_DATA;
					end
					else begin
						cnt_enable <= 1'b0;
						state      <= SPIM_STATE_SPI_DONE;
					end
				end

				SPIM_STATE_SHFT_N_LD_TX_DATA: begin
					sclk  <= ModePOL;
					state <= SPIM_STATE_SEND_TX_DATA;
				end

				SPIM_STATE_SPI_DONE: begin
					mosi       <= 1'b0;
					cnt_enable <= 1'b0;
					sclk       <= ModePOL;
					state      <= SPIM_STATE_IDLE;
				end

				default: begin
					ss         <= 1'b1;
					cnt_enable <= 1'b0;
					mosi       <= 1'b0;
					sclk       <= ModePOL;
					state      <= SPIM_STATE_IDLE;
				end
				endcase
			end
		end
	end

	/* "CPHA == 0" State Machine implementation */
	else if (ModeCPHA == 0 && HighSpeedMode) begin
		always @(posedge clk_fin) begin
			if (reset) begin
				state <= SPIM_STATE_IDLE;
			end
			else begin
				case (state)
				SPIM_STATE_IDLE: begin
					ss         <= 1'b1;
					cnt_enable <= 1'b0;
					sclk       <= ModePOL;
					tde        <= dpMOSI_fifo_empty;
					rde_reg    <= rde;
					state      <= (dpMOSI_fifo_empty && rde_reg) ? SPIM_STATE_IDLE : SPIM_STATE_LOAD_TX_DATA;
				end

				SPIM_STATE_LOAD_TX_DATA: begin
					ss    <= 1'b0;
					sclk  <= ModePOL;
					state <= SPIM_STATE_SEND_TX_DATA_2;
				end

				SPIM_STATE_SEND_TX_DATA_2: begin
					mosi  <= mosi_from_dp;
					state <= SPIM_STATE_WAIT;
				end

				SPIM_STATE_WAIT: begin // 15
					cnt_enable <= 1'b1;
					sclk       <= ~ModePOL;
					state      <= SPIM_STATE_CAPT_RX_DATA;
				end

				SPIM_STATE_SEND_TX_DATA: begin // 13
					if (dpcounter_one) begin
						ld_ident <= 1'b0;
					end
					sclk    <= ~ModePOL;
					rde_reg <= rde;
					state   <= SPIM_STATE_CAPT_RX_DATA;
				end

				SPIM_STATE_CAPT_RX_DATA: begin // 14
					mosi <= mosi_from_dp_reg;
					sclk <= ModePOL;
					if (count[4:0] == 5'h6 && !dpMOSI_fifo_empty) begin
						state <= SPIM_STATE_SHFT_N_LD_TX_DATA;
					end
					else if ((count[4:0] == 5'h0 || count[4:0] == 5'h2) && !ld_ident) begin
						state <= SPIM_STATE_SPI_DONE;
					end
					else begin
						state <= SPIM_STATE_SEND_TX_DATA;
					end
				end

				SPIM_STATE_SHFT_N_LD_TX_DATA: begin // 5
					sclk     <= ~ModePOL;
					ld_ident <= 1'b1;
					state    <= SPIM_STATE_CAPT_RX_DATA;
				end

				SPIM_STATE_SPI_DONE: begin
					ss         <= 1'b1;
					cnt_enable <= 1'b0;
					sclk       <= ModePOL;
					state      <= SPIM_STATE_IDLE;
				end

				default: begin
					ss         <= 1'b1;
					cnt_enable <= 1'b0;
					ld_ident   <= 1'b0;
					sclk       <= ModePOL;
					state      <= SPIM_STATE_IDLE;
				end
				endcase
			end
		end
	end

	else begin
		always @(posedge clk_fin) begin
			if (reset) begin
				state <= SPIM_STATE_IDLE;
			end
			else begin
				case (state)
				SPIM_STATE_IDLE: begin
					ss         <= 1'b1;
					cnt_enable <= 1'b0;
					mosi       <= 1'b0;
					sclk       <= ModePOL;
					tde        <= dpMOSI_fifo_empty;
					rde_reg    <= rde;
					state      <= (dpMOSI_fifo_empty && rde_reg) ? SPIM_STATE_IDLE : SPIM_STATE_LOAD_TX_DATA;
				end

				SPIM_STATE_LOAD_TX_DATA: begin
					ss    <= 1'b0;
					sclk  <= ModePOL;
					state <= SPIM_STATE_SEND_TX_DATA_2;
				end

				SPIM_STATE_SEND_TX_DATA_2: begin
					mosi  <= mosi_from_dp;
					state <= SPIM_STATE_CAPT_RX_DATA;
				end

				SPIM_STATE_CAPT_RX_DATA: begin // 15
					cnt_enable <= 1'b1;
					sclk       <= ~ModePOL;
					state      <= (count[4:0] == 5'h5 && !dpMOSI_fifo_empty) ? SPIM_STATE_SHFT_N_LD_TX_DATA : SPIM_STATE_SEND_TX_DATA;
				end

				SPIM_STATE_SEND_TX_DATA: begin // 14
					sclk    <= ModePOL;
					rde_reg <= rde;
					if (count[4:0] == 5'h2 && !ld_ident) begin
						mosi  <= 1'b0;
						state <= SPIM_STATE_SPI_DONE;
					end
					else begin
						if (count[4:0] == 5'h2) begin
							ld_ident <= 1'b0;
						end
						mosi  <= mosi_from_dp;
						state <= SPIM_STATE_CAPT_RX_DATA;
					end
				end

				SPIM_STATE_SHFT_N_LD_TX_DATA: begin // 4
					sclk     <= ModePOL;
					ld_ident <= 1'b1;
					mosi     <= mosi_from_dp;
					state    <= SPIM_STATE_CAPT_RX_DATA;
				end

				SPIM_STATE_SPI_DONE: begin
					mosi       <= 1'b0;
					ss         <= 1'b1;
					cnt_enable <= 1'b0;
					sclk       <= ModePOL;
					state      <= SPIM_STATE_IDLE;
				end

				default: begin
					ss         <= 1'b1;
					mosi       <= 1'b0;
					cnt_enable <= 1'b0;
					ld_ident   <= 1'b0;
					sclk       <= ModePOL;
					state      <= SPIM_STATE_IDLE;
				end
				endcase
			end
		end
	end
	endgenerate

	/* Status Register bits */
	localparam SPIM_STS_SPI_DONE_BIT         = 3'd0;
	localparam SPIM_STS_TX_FIFO_EMPTY_BIT    = 3'd1;
	localparam SPIM_STS_TX_FIFO_NOT_FULL_BIT = 3'd2;
	localparam SPIM_STS_BYTE_COMPLETE_BIT    = 3'd3;
	localparam SPIM_STS_SPI_IDLE_BIT         = 3'd4;
	wire [6:0] tx_status;
	assign tx_status[SPIM_STS_SPI_DONE_BIT]         = (state == SPIM_STATE_SPI_DONE);
	assign tx_status[SPIM_STS_TX_FIFO_EMPTY_BIT]    = dpMOSI_fifo_empty;
	assign tx_status[SPIM_STS_TX_FIFO_NOT_FULL_BIT] = dpMOSI_fifo_not_full;
	assign tx_status[SPIM_STS_BYTE_COMPLETE_BIT]    = dpcounter_one;
	assign tx_status[SPIM_STS_SPI_IDLE_BIT]         = (state == SPIM_STATE_IDLE);
	assign tx_status[6:5]                           = 2'h0;
	assign tx_drq                                   = dpMOSI_fifo_not_full;

	cy_psoc3_statusi #(.cy_force_order(1), .cy_md_select(7'h09), .cy_int_mask(7'h00))
	TxStsReg(
		/* input            */ .clock(clk_fin),
		/* input    [06:00] */ .status(tx_status),
		/* output           */ .interrupt(tx_interpt)
	);

	localparam SPIM_STS_RX_FIFO_FULL_BIT      = 3'd4;
	localparam SPIM_STS_RX_FIFO_NOT_EMPTY_BIT = 3'd5;
	localparam SPIM_STS_RX_FIFO_OVERRUN_BIT   = 3'd6;
	wire [6:0] rx_status;
	assign rx_status[SPIM_STS_RX_FIFO_FULL_BIT]      = dpMISO_fifo_full;
	assign rx_status[SPIM_STS_RX_FIFO_NOT_EMPTY_BIT] = dpMISO_fifo_not_empty;
	assign rx_status[SPIM_STS_RX_FIFO_OVERRUN_BIT]   = dpcounter_one & dpMISO_fifo_full;
	assign rx_status[3:0]                            = 4'h0;
	assign rx_drq                                    = dpMISO_fifo_not_empty;

	cy_psoc3_statusi #(.cy_force_order(1), .cy_md_select(7'h40), .cy_int_mask(7'h00))
	RxStsReg(
		/* input            */ .clock(clk_fin),
		/* input    [06:00] */ .status(rx_status),
		/* output           */ .interrupt(rx_interpt)
	);

	localparam SR8 = 8'd8;
	localparam [2:0] dpMsbVal   = (NumberOfDataBits % 8) - 3'b1;
	localparam [7:0] dpMISOMask = (NumberOfDataBits == 8 || NumberOfDataBits == 16) ? 8'b1111_1111 :
								  (NumberOfDataBits == 7 || NumberOfDataBits == 15) ? 8'b0111_1111 :
								  (NumberOfDataBits == 6 || NumberOfDataBits == 14) ? 8'b0011_1111 :
								  (NumberOfDataBits == 5 || NumberOfDataBits == 13) ? 8'b0001_1111 :
								  (NumberOfDataBits == 4 || NumberOfDataBits == 12) ? 8'b0000_1111 :
								  (NumberOfDataBits == 3 || NumberOfDataBits == 11) ? 8'b0000_0111 :
								  (NumberOfDataBits == 2 || NumberOfDataBits == 10) ? 8'b0000_0011 :
								  (NumberOfDataBits == 9) ? 8'b0000_0001 : 8'b1111_1111;
	localparam [1:0] dynShiftDir     = (ShiftDir == SPIM_MSB_FIRST) ? 2'd1 : 2'd2;
	localparam f1_ld_src = (ModeCPHA == 1) ? `SC_FIFO1_ALU : `SC_FIFO1__A1;

	generate
	if (NumberOfDataBits <= SR8) begin: sR8
		localparam dp8_cfg = {
			`CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
			`CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
			`CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
			`CS_CMP_SEL_CFGA, /*CFGRAM0:          IDLE */
			`CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
			`CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC_NONE,
			`CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
			`CS_CMP_SEL_CFGA, /*CFGRAM1:          LOAD F0 to A0 */
			`CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
			dynShiftDir, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
			`CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
			`CS_CMP_SEL_CFGA, /*CFGRAM2:          Change Shift Out */
			`CS_ALU_OP_PASS, `CS_SRCA_A1, `CS_SRCB_D0,
			dynShiftDir, `CS_A0_SRC_NONE, `CS_A1_SRC__ALU,
			`CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
			`CS_CMP_SEL_CFGA, /*CFGRAM3:          Capture Shift In */
			`CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
			dynShiftDir, `CS_A0_SRC___F0, `CS_A1_SRC_NONE,
			`CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
			`CS_CMP_SEL_CFGA, /*CFGRAM4:          LDSHIFT */
			`CS_ALU_OP_PASS, `CS_SRCA_A1, `CS_SRCB_D0,
			dynShiftDir, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
			`CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
			`CS_CMP_SEL_CFGA, /*CFGRAM5:         END */
			`CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
			dynShiftDir, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
			`CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
			`CS_CMP_SEL_CFGA, /*CFGRAM6:          Change Shift Out */
			`CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
			dynShiftDir, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
			`CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
			`CS_CMP_SEL_CFGA, /*CFGRAM7:         */
			dpMISOMask, 8'h00,    /*CFG9:           */
			8'hFF, 8'hFF,    /*CFG11-10:           */
			`SC_CMPB_A1_D1, `SC_CMPA_A1_D1, `SC_CI_B_ARITH,
			`SC_CI_A_ARITH, `SC_C1_MASK_DSBL, `SC_C0_MASK_DSBL,
			`SC_A_MASK_ENBL, `SC_DEF_SI_0, `SC_SI_B_DEFSI,
			`SC_SI_A_ROUTE, /*CFG13-12:           */
			`SC_A0_SRC_ACC, ShiftDir, 1'h0,
			1'h0, f1_ld_src, `SC_FIFO0_BUS,
			`SC_MSB_ENBL, dpMsbVal, `SC_MSB_NOCHN,
			`SC_FB_NOCHN, `SC_CMP1_NOCHN,
			`SC_CMP0_NOCHN, /*CFG15-14:           */
			3'h00, `SC_FIFO_SYNC_NONE, 6'h00, `SC_FIFO_CLK__DP,`SC_FIFO_CAP_AX,
			`SC_FIFO_LEVEL,`SC_FIFO_ASYNC,`SC_EXTCRC_DSBL,
			`SC_WRK16CAT_DSBL  /*CFG17-16:           */
		};

		cy_psoc3_dp8 #(.cy_dpconfig_a(dp8_cfg))
		Dp(
			/*  input           */ .clk(clk_fin),
			/*  input           */ .reset(reset),
			/*  input   [02:00] */ .cs_addr(state),
			/*  input           */ .route_si(miso),
			/*  input           */ .route_ci(1'b0),
			/*  input           */ .f0_load(1'b0),
			/*  input           */ .f1_load(load_rx_data),
			/*  input           */ .d0_load(1'b0),
			/*  input           */ .d1_load(1'b0),
			/*  output          */ .ce0(),
			/*  output          */ .cl0(),
			/*  output          */ .z0(),
			/*  output          */ .ff0(),
			/*  output          */ .ce1(),
			/*  output          */ .cl1(),
			/*  output          */ .z1(),
			/*  output          */ .ff1(),
			/*  output          */ .ov_msb(),
			/*  output          */ .co_msb(),
			/*  output          */ .cmsb(),
			/*  output          */ .so(mosi_from_dp),
			/*  output          */ .f0_bus_stat(dpMOSI_fifo_not_full),
			/*  output          */ .f0_blk_stat(dpMOSI_fifo_empty),
			/*  output          */ .f1_bus_stat(dpMISO_fifo_not_empty),
			/*  output          */ .f1_blk_stat(dpMISO_fifo_full)
			);
	end /* NumberOfDataBits <= SR8 */
	else begin : sR16    /* NumberOfDataBits > 8 */
		localparam [1:0] dp16MSBSIChoice = (ShiftDir == SPIM_MSB_FIRST) ? `SC_SI_A_CHAIN : `SC_SI_A_ROUTE;
		localparam [1:0] dp16LSBSIChoice = (ShiftDir == SPIM_MSB_FIRST) ? `SC_SI_A_ROUTE : `SC_SI_A_CHAIN;

		localparam dp16_lsb_cfg = {
			`CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
			`CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
			`CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
			`CS_CMP_SEL_CFGA, /*CFGRAM0:          IDLE */
			`CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
			`CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC_NONE,
			`CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
			`CS_CMP_SEL_CFGA, /*CFGRAM1:          LOAD F0 to A0 */
			`CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
			dynShiftDir, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
			`CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
			`CS_CMP_SEL_CFGA, /*CFGRAM2:          Change Shift Out */
			`CS_ALU_OP_PASS, `CS_SRCA_A1, `CS_SRCB_D0,
			dynShiftDir, `CS_A0_SRC_NONE, `CS_A1_SRC__ALU,
			`CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
			`CS_CMP_SEL_CFGA, /*CFGRAM3:          Capture Shift In */
			`CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
			dynShiftDir, `CS_A0_SRC___F0, `CS_A1_SRC_NONE,
			`CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
			`CS_CMP_SEL_CFGA, /*CFGRAM4:          LDSHIFT */
			`CS_ALU_OP_PASS, `CS_SRCA_A1, `CS_SRCB_D0,
			dynShiftDir, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
			`CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
			`CS_CMP_SEL_CFGA, /*CFGRAM5:          END */
			`CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
			dynShiftDir, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
			`CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
			`CS_CMP_SEL_CFGA, /*CFGRAM6:          Change Shift Out */
			`CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
			dynShiftDir, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
			`CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
			`CS_CMP_SEL_CFGA, /*CFGRAM7:          */
			8'hFF, 8'h00, /*CFG9:          */
			8'hFF, 8'hFF, /*CFG11-10:          */
			`SC_CMPB_A1_D1, `SC_CMPA_A1_D1, `SC_CI_B_ARITH,
			`SC_CI_A_ARITH, `SC_C1_MASK_DSBL, `SC_C0_MASK_DSBL,
			`SC_A_MASK_DSBL, `SC_DEF_SI_0, `SC_SI_B_DEFSI,
			dp16LSBSIChoice, /*CFG13-12:           */
			`SC_A0_SRC_ACC, ShiftDir, 1'h0,
			1'h0, f1_ld_src, `SC_FIFO0_BUS,
			`SC_MSB_DSBL, `SC_MSB_BIT7, `SC_MSB_NOCHN,
			`SC_FB_NOCHN, `SC_CMP1_NOCHN,
			`SC_CMP0_NOCHN, /*CFG15-14:           */
			 3'h00, `SC_FIFO_SYNC_NONE, 6'h00, `SC_FIFO_CLK__DP,`SC_FIFO_CAP_AX,
			`SC_FIFO_LEVEL,`SC_FIFO_ASYNC,`SC_EXTCRC_DSBL,
			`SC_WRK16CAT_DSBL /*CFG17-16:           */
		};

		localparam dp16_msb_cfg = {
			`CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
			`CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
			`CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
			`CS_CMP_SEL_CFGA, /*CFGRAM0:          IDLE */
			`CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
			`CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC_NONE,
			`CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
			`CS_CMP_SEL_CFGA, /*CFGRAM1:          LOAD F0 to A0 */
			`CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
			dynShiftDir, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
			`CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
			`CS_CMP_SEL_CFGA, /*CFGRAM2:          Change Shift Out */
			`CS_ALU_OP_PASS, `CS_SRCA_A1, `CS_SRCB_D0,
			dynShiftDir, `CS_A0_SRC_NONE, `CS_A1_SRC__ALU,
			`CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
			`CS_CMP_SEL_CFGA, /*CFGRAM3:          Capture Shift In */
			`CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
			dynShiftDir, `CS_A0_SRC___F0, `CS_A1_SRC_NONE,
			`CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
			`CS_CMP_SEL_CFGA, /*CFGRAM4:          LDSHIFT */
			`CS_ALU_OP_PASS, `CS_SRCA_A1, `CS_SRCB_D0,
			dynShiftDir, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
			`CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
			`CS_CMP_SEL_CFGA, /*CFGRAM5:          END */
			`CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
			dynShiftDir, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
			`CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
			`CS_CMP_SEL_CFGA, /*CFGRAM6:          Change Shift Out */
			`CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
			dynShiftDir, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
			`CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
			`CS_CMP_SEL_CFGA, /*CFGRAM7:          */
			dpMISOMask, 8'h00, /*CFG9:          */
			8'hFF, 8'hFF, /*CFG11-10:          */
			`SC_CMPB_A1_D1, `SC_CMPA_A1_D1, `SC_CI_B_ARITH,
			`SC_CI_A_ARITH, `SC_C1_MASK_DSBL, `SC_C0_MASK_DSBL,
			`SC_A_MASK_ENBL, `SC_DEF_SI_0, `SC_SI_B_DEFSI,
			dp16MSBSIChoice, /*CFG13-12:           */
			`SC_A0_SRC_ACC, ShiftDir, 1'h0,
			1'h0, f1_ld_src, `SC_FIFO0_BUS,
			`SC_MSB_ENBL, dpMsbVal, `SC_MSB_NOCHN,
			`SC_FB_NOCHN, `SC_CMP1_NOCHN,
			`SC_CMP0_NOCHN, /*CFG15-14:           */
			 3'h00, `SC_FIFO_SYNC_NONE, 6'h00, `SC_FIFO_CLK__DP,`SC_FIFO_CAP_AX,
			`SC_FIFO_LEVEL,`SC_FIFO_ASYNC,`SC_EXTCRC_DSBL,
			`SC_WRK16CAT_DSBL /*CFG17-16:           */
		};

		wire mosi_from_dpL;
		wire mosi_from_dpR;
		wire nc1, nc2, nc3, nc4;
		cy_psoc3_dp16 #(.cy_dpconfig_a(dp16_lsb_cfg), .cy_dpconfig_b(dp16_msb_cfg))
		Dp(
				/*  input           */ .clk(clk_fin),
				/*  input           */ .reset(reset),
				/*  input   [02:00] */ .cs_addr(state),
				/*  input           */ .route_si(miso),
				/*  input           */ .route_ci(1'b0),
				/*  input           */ .f0_load(1'b0),
				/*  input           */ .f1_load(load_rx_data),
				/*  input           */ .d0_load(1'b0),
				/*  input           */ .d1_load(1'b0),
				/*  output          */ .ce0(),
				/*  output          */ .cl0(),
				/*  output          */ .z0(),
				/*  output          */ .ff0(),
				/*  output          */ .ce1(),
				/*  output          */ .cl1(),
				/*  output          */ .z1(),
				/*  output          */ .ff1(),
				/*  output          */ .ov_msb(),
				/*  output          */ .co_msb(),
				/*  output          */ .cmsb(),
				/*  output          */ .so({mosi_from_dpL,mosi_from_dpR}),
				/*  output          */ .f0_bus_stat({dpMOSI_fifo_not_full,  nc1}),
				/*  output          */ .f0_blk_stat({dpMOSI_fifo_empty,     nc2}),
				/*  output          */ .f1_bus_stat({dpMISO_fifo_not_empty, nc3}),
				/*  output          */ .f1_blk_stat({dpMISO_fifo_full,      nc4})
		);

		assign mosi_from_dp = (ShiftDir == SPIM_MSB_FIRST) ? mosi_from_dpL : mosi_from_dpR;

	end /* NumberOfDataBits <= sR16 */
	endgenerate

endmodule
`endif /* B_SPIM_HFC_v0_1__V_ALREADY_INCLUDED */
