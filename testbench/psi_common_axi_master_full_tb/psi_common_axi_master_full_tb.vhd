------------------------------------------------------------
-- Copyright (c) 2019 by Paul Scherrer Institute, Switzerland
-- All rights reserved.
------------------------------------------------------------

------------------------------------------------------------
-- Testbench generated by TbGen.py
------------------------------------------------------------
-- see Library/Python/TbGenerator

------------------------------------------------------------
-- Libraries
------------------------------------------------------------
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

library work;
	use work.psi_common_math_pkg.all;
	use work.psi_common_logic_pkg.all;

library work;
	use work.psi_tb_txt_util.all;
	use work.psi_tb_compare_pkg.all;
	use work.psi_tb_activity_pkg.all;
	use work.psi_tb_axi_pkg.all;

library work;
	use work.psi_common_axi_master_full_tb_pkg.all;

library work;
	use work.psi_common_axi_master_full_tb_case_simple_tf.all;
	use work.psi_common_axi_master_full_tb_case_axi_hs.all;
	use work.psi_common_axi_master_full_tb_case_user_hs.all;
	use work.psi_common_axi_master_full_tb_case_large.all;

------------------------------------------------------------
-- Entity Declaration
------------------------------------------------------------
entity psi_common_axi_master_full_tb is
	generic (
		DataWidth_g : natural := 16;
		ImplRead_g : boolean := true;
		ImplWrite_g : boolean := true 
	);
end entity;

------------------------------------------------------------
-- Architecture
------------------------------------------------------------
architecture sim of psi_common_axi_master_full_tb is
	-- *** Fixed Generics ***
	constant AxiAddrWidth_g : natural := 32;
	constant AxiMaxBeats_g : natural := 16;
	constant AxiFifoDepth_g : natural := 32;
	constant AxiMaxOpenTrasactions_g : natural := 3;
	constant UserTransactionSizeBits_g : natural := 10;
	constant DataFifoDepth_g : natural := 10;
	constant RamBehavior_g : string := "RBW";
	constant AxiDataWidth_g : natural := 32;
	
	-- *** Not Assigned Generics (default values) ***
	
	-- *** Exported Generics ***
	constant Generics_c : Generics_t := (
		DataWidth_g => DataWidth_g,
		ImplRead_g => ImplRead_g,
		ImplWrite_g => ImplWrite_g);
	
	-- *** TB Control ***
	signal TbRunning : boolean := True;
	signal NextCase : integer := -1;
	signal ProcessDone : std_logic_vector(0 to 3) := (others => '0');
	constant AllProcessesDone_c : std_logic_vector(0 to 3) := (others => '1');
	constant TbProcNr_user_cmd_c : integer := 0;
	constant TbProcNr_user_data_c : integer := 1;
	constant TbProcNr_user_resp_c : integer := 2;
	constant TbProcNr_axi_c : integer := 3;
	
	------------------------------------------------------------
	-- Axi
	------------------------------------------------------------
	
	-- *** DUT Signals ***
	signal M_Axi_Aclk : std_logic := '1';
	signal M_Axi_Aresetn : std_logic := '0';
	signal CmdWr_Addr : std_logic_vector(AxiAddrWidth_g-1 downto 0) := (others => '0');
	signal CmdWr_Size : std_logic_vector(UserTransactionSizeBits_g-1 downto 0) := (others => '0');
	signal CmdWr_LowLat : std_logic := '0';
	signal CmdWr_Vld : std_logic := '0';
	signal CmdWr_Rdy : std_logic := '0';
	signal CmdRd_Addr : std_logic_vector(AxiAddrWidth_g-1 downto 0) := (others => '0');
	signal CmdRd_Size : std_logic_vector(UserTransactionSizeBits_g-1 downto 0) := (others => '0');
	signal CmdRd_LowLat : std_logic := '0';
	signal CmdRd_Vld : std_logic := '0';
	signal CmdRd_Rdy : std_logic := '0';
	signal WrDat_Data : std_logic_vector(DataWidth_g-1 downto 0) := (others => '0');
	signal WrDat_Vld : std_logic := '0';
	signal WrDat_Rdy : std_logic := '0';
	signal RdDat_Data : std_logic_vector(DataWidth_g-1 downto 0) := (others => '0');
	signal RdDat_Vld : std_logic := '0';
	signal RdDat_Rdy : std_logic := '0';
	signal Wr_Done : std_logic := '0';
	signal Wr_Error : std_logic := '0';
	signal Rd_Done : std_logic := '0';
	signal Rd_Error : std_logic := '0';
	signal axi_ms : axi_ms_t;
	signal axi_sm : axi_sm_t;
	
	
	
begin
	------------------------------------------------------------
	-- DUT Instantiation
	------------------------------------------------------------
	i_dut : entity work.psi_common_axi_master_full
		generic map (
			AxiDataWidth_g => AxiDataWidth_g,
			ImplRead_g => ImplRead_g,
			ImplWrite_g => ImplWrite_g,
			AxiAddrWidth_g => AxiAddrWidth_g,
			AxiMaxBeats_g => AxiMaxBeats_g,
			AxiMaxOpenTrasactions_g => AxiMaxOpenTrasactions_g,
			UserTransactionSizeBits_g => UserTransactionSizeBits_g,
			DataFifoDepth_g => DataFifoDepth_g,
			AxiFifoDepth_g => AxiFifoDepth_g,
			DataWidth_g => DataWidth_g,
			RamBehavior_g => RamBehavior_g
		)
		port map (
			M_Axi_Aclk => M_Axi_Aclk,
			M_Axi_Aresetn => M_Axi_Aresetn,
			CmdWr_Addr => CmdWr_Addr,
			CmdWr_Size => CmdWr_Size,
			CmdWr_LowLat => CmdWr_LowLat,
			CmdWr_Vld => CmdWr_Vld,
			CmdWr_Rdy => CmdWr_Rdy,
			CmdRd_Addr => CmdRd_Addr,
			CmdRd_Size => CmdRd_Size,
			CmdRd_LowLat => CmdRd_LowLat,
			CmdRd_Vld => CmdRd_Vld,
			CmdRd_Rdy => CmdRd_Rdy,
			WrDat_Data => WrDat_Data,
			WrDat_Vld => WrDat_Vld,
			WrDat_Rdy => WrDat_Rdy,
			RdDat_Data => RdDat_Data,
			RdDat_Vld => RdDat_Vld,
			RdDat_Rdy => RdDat_Rdy,
			Wr_Done => Wr_Done,
			Wr_Error => Wr_Error,
			Rd_Done => Rd_Done,
			Rd_Error => Rd_Error,
			M_Axi_AwAddr => axi_ms.awaddr,
			M_Axi_AwLen => axi_ms.awlen,
			M_Axi_AwSize => axi_ms.awsize,
			M_Axi_AwBurst => axi_ms.awburst,
			M_Axi_AwLock => axi_ms.awlock,
			M_Axi_AwCache => axi_ms.awcache,
			M_Axi_AwProt => axi_ms.awprot,
			M_Axi_AwValid => axi_ms.awvalid,
			M_Axi_AwReady => axi_sm.awready,
			M_Axi_WData => axi_ms.wdata,
			M_Axi_WStrb => axi_ms.wstrb,
			M_Axi_WLast => axi_ms.wlast,
			M_Axi_WValid => axi_ms.wvalid,
			M_Axi_WReady => axi_sm.wready,
			M_Axi_BResp => axi_sm.bresp,
			M_Axi_BValid => axi_sm.bvalid,
			M_Axi_BReady => axi_ms.bready,
			M_Axi_ArAddr => axi_ms.araddr,
			M_Axi_ArLen => axi_ms.arlen,
			M_Axi_ArSize => axi_ms.arsize,
			M_Axi_ArBurst => axi_ms.arburst,
			M_Axi_ArLock => axi_ms.arlock,
			M_Axi_ArCache => axi_ms.arcache,
			M_Axi_ArProt => axi_ms.arprot,
			M_Axi_ArValid => axi_ms.arvalid,
			M_Axi_ArReady => axi_sm.arready,
			M_Axi_RData => axi_sm.rdata,
			M_Axi_RResp => axi_sm.rresp,
			M_Axi_RLast => axi_sm.rlast,
			M_Axi_RValid => axi_sm.rvalid,
			M_Axi_RReady => axi_ms.rready
		);
	
	------------------------------------------------------------
	-- Testbench Control !DO NOT EDIT!
	------------------------------------------------------------
	p_tb_control : process
	begin
		wait until M_Axi_Aresetn = '1';
		-- simple_tf
		NextCase <= 0;
		wait until ProcessDone = AllProcessesDone_c;
		-- axi_hs
		NextCase <= 1;
		wait until ProcessDone = AllProcessesDone_c;
		-- user_hs
		NextCase <= 2;
		wait until ProcessDone = AllProcessesDone_c;
		-- all_shifts
		NextCase <= 3;
		wait until ProcessDone = AllProcessesDone_c;
		TbRunning <= false;
		wait;
	end process;
	
	------------------------------------------------------------
	-- Clocks !DO NOT EDIT!
	------------------------------------------------------------
	p_clock_M_Axi_Aclk : process
		constant Frequency_c : real := real(100e6);
	begin
		while TbRunning loop
			wait for 0.5*(1 sec)/Frequency_c;
			M_Axi_Aclk <= not M_Axi_Aclk;
		end loop;
		wait;
	end process;
	
	
	------------------------------------------------------------
	-- Resets
	------------------------------------------------------------
	p_rst_M_Axi_Aresetn : process
	begin
		wait for 1 us;
		-- Wait for two clk edges to ensure reset is active for at least one edge
		wait until rising_edge(M_Axi_Aclk);
		wait until rising_edge(M_Axi_Aclk);
		M_Axi_Aresetn <= '1';
		wait;
	end process;
	
	
	------------------------------------------------------------
	-- Processes !DO NOT EDIT!
	------------------------------------------------------------
	-- *** user_cmd ***
	p_user_cmd : process
	begin
		-- simple_tf
		wait until NextCase = 0;
		ProcessDone(TbProcNr_user_cmd_c) <= '0';
		work.psi_common_axi_master_full_tb_case_simple_tf.user_cmd(M_Axi_Aclk, CmdWr_Addr, CmdWr_Size, CmdWr_LowLat, CmdWr_Vld, CmdWr_Rdy, CmdRd_Addr, CmdRd_Size, CmdRd_LowLat, CmdRd_Vld, CmdRd_Rdy, Generics_c);
		wait for 1 ps;
		ProcessDone(TbProcNr_user_cmd_c) <= '1';
		-- axi_hs
		wait until NextCase = 1;
		ProcessDone(TbProcNr_user_cmd_c) <= '0';
		work.psi_common_axi_master_full_tb_case_axi_hs.user_cmd(M_Axi_Aclk, CmdWr_Addr, CmdWr_Size, CmdWr_LowLat, CmdWr_Vld, CmdWr_Rdy, CmdRd_Addr, CmdRd_Size, CmdRd_LowLat, CmdRd_Vld, CmdRd_Rdy, Generics_c);
		wait for 1 ps;
		ProcessDone(TbProcNr_user_cmd_c) <= '1';
		-- user_hs
		wait until NextCase = 2;
		ProcessDone(TbProcNr_user_cmd_c) <= '0';
		work.psi_common_axi_master_full_tb_case_user_hs.user_cmd(M_Axi_Aclk, CmdWr_Addr, CmdWr_Size, CmdWr_LowLat, CmdWr_Vld, CmdWr_Rdy, CmdRd_Addr, CmdRd_Size, CmdRd_LowLat, CmdRd_Vld, CmdRd_Rdy, Generics_c);
		wait for 1 ps;
		ProcessDone(TbProcNr_user_cmd_c) <= '1';
		-- all_shifts
		wait until NextCase = 3;
		ProcessDone(TbProcNr_user_cmd_c) <= '0';
		work.psi_common_axi_master_full_tb_case_large.user_cmd(M_Axi_Aclk, CmdWr_Addr, CmdWr_Size, CmdWr_LowLat, CmdWr_Vld, CmdWr_Rdy, CmdRd_Addr, CmdRd_Size, CmdRd_LowLat, CmdRd_Vld, CmdRd_Rdy, Generics_c);
		wait for 1 ps;
		ProcessDone(TbProcNr_user_cmd_c) <= '1';
		wait;
	end process;
	
	-- *** user_data ***
	p_user_data : process
	begin
		-- simple_tf
		wait until NextCase = 0;
		ProcessDone(TbProcNr_user_data_c) <= '0';
		work.psi_common_axi_master_full_tb_case_simple_tf.user_data(M_Axi_Aclk, WrDat_Data, WrDat_Vld, WrDat_Rdy, RdDat_Data, RdDat_Vld, RdDat_Rdy, Generics_c);
		wait for 1 ps;
		ProcessDone(TbProcNr_user_data_c) <= '1';
		-- axi_hs
		wait until NextCase = 1;
		ProcessDone(TbProcNr_user_data_c) <= '0';
		work.psi_common_axi_master_full_tb_case_axi_hs.user_data(M_Axi_Aclk, WrDat_Data, WrDat_Vld, WrDat_Rdy, RdDat_Data, RdDat_Vld, RdDat_Rdy, Generics_c);
		wait for 1 ps;
		ProcessDone(TbProcNr_user_data_c) <= '1';
		-- user_hs
		wait until NextCase = 2;
		ProcessDone(TbProcNr_user_data_c) <= '0';
		work.psi_common_axi_master_full_tb_case_user_hs.user_data(M_Axi_Aclk, WrDat_Data, WrDat_Vld, WrDat_Rdy, RdDat_Data, RdDat_Vld, RdDat_Rdy, Generics_c);
		wait for 1 ps;
		ProcessDone(TbProcNr_user_data_c) <= '1';
		-- all_shifts
		wait until NextCase = 3;
		ProcessDone(TbProcNr_user_data_c) <= '0';
		work.psi_common_axi_master_full_tb_case_large.user_data(M_Axi_Aclk, WrDat_Data, WrDat_Vld, WrDat_Rdy, RdDat_Data, RdDat_Vld, RdDat_Rdy, Generics_c);
		wait for 1 ps;
		ProcessDone(TbProcNr_user_data_c) <= '1';
		wait;
	end process;
	
	-- *** user_resp ***
	p_user_resp : process
	begin
		-- simple_tf
		wait until NextCase = 0;
		ProcessDone(TbProcNr_user_resp_c) <= '0';
		work.psi_common_axi_master_full_tb_case_simple_tf.user_resp(M_Axi_Aclk, Wr_Done, Wr_Error, Rd_Done, Rd_Error, Generics_c);
		wait for 1 ps;
		ProcessDone(TbProcNr_user_resp_c) <= '1';
		-- axi_hs
		wait until NextCase = 1;
		ProcessDone(TbProcNr_user_resp_c) <= '0';
		work.psi_common_axi_master_full_tb_case_axi_hs.user_resp(M_Axi_Aclk, Wr_Done, Wr_Error, Rd_Done, Rd_Error, Generics_c);
		wait for 1 ps;
		ProcessDone(TbProcNr_user_resp_c) <= '1';
		-- user_hs
		wait until NextCase = 2;
		ProcessDone(TbProcNr_user_resp_c) <= '0';
		work.psi_common_axi_master_full_tb_case_user_hs.user_resp(M_Axi_Aclk, Wr_Done, Wr_Error, Rd_Done, Rd_Error, Generics_c);
		wait for 1 ps;
		ProcessDone(TbProcNr_user_resp_c) <= '1';
		-- all_shifts
		wait until NextCase = 3;
		ProcessDone(TbProcNr_user_resp_c) <= '0';
		work.psi_common_axi_master_full_tb_case_large.user_resp(M_Axi_Aclk, Wr_Done, Wr_Error, Rd_Done, Rd_Error, Generics_c);
		wait for 1 ps;
		ProcessDone(TbProcNr_user_resp_c) <= '1';
		wait;
	end process;
	
	-- *** axi ***
	p_axi : process
	begin
		-- simple_tf
		wait until NextCase = 0;
		ProcessDone(TbProcNr_axi_c) <= '0';
		work.psi_common_axi_master_full_tb_case_simple_tf.axi(M_Axi_Aclk, axi_ms, axi_sm, Generics_c);
		wait for 1 ps;
		ProcessDone(TbProcNr_axi_c) <= '1';
		-- axi_hs
		wait until NextCase = 1;
		ProcessDone(TbProcNr_axi_c) <= '0';
		work.psi_common_axi_master_full_tb_case_axi_hs.axi(M_Axi_Aclk, axi_ms, axi_sm, Generics_c);
		wait for 1 ps;
		ProcessDone(TbProcNr_axi_c) <= '1';
		-- user_hs
		wait until NextCase = 2;
		ProcessDone(TbProcNr_axi_c) <= '0';
		work.psi_common_axi_master_full_tb_case_user_hs.axi(M_Axi_Aclk, axi_ms, axi_sm, Generics_c);
		wait for 1 ps;
		ProcessDone(TbProcNr_axi_c) <= '1';
		-- all_shifts
		wait until NextCase = 3;
		ProcessDone(TbProcNr_axi_c) <= '0';
		work.psi_common_axi_master_full_tb_case_large.axi(M_Axi_Aclk, axi_ms, axi_sm, Generics_c);
		wait for 1 ps;
		ProcessDone(TbProcNr_axi_c) <= '1';
		wait;
	end process;
	
	
end;
