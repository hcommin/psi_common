------------------------------------------------------------------------------
--  Copyright (c) 2018 by Paul Scherrer Institute, Switzerland
--  All rights reserved.
--  Authors: Oliver Bruendler
------------------------------------------------------------------------------

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
	use work.psi_common_array_pkg.all;
	use work.psi_tb_compare_pkg.all;

------------------------------------------------------------
-- Entity Declaration
------------------------------------------------------------
entity psi_common_par_tdm_tb is
end entity;

------------------------------------------------------------
-- Architecture
------------------------------------------------------------
architecture sim of psi_common_par_tdm_tb is
	-- *** Fixed Generics ***
	constant ChannelCount_g : natural := 3;
	constant ChannelWidth_g : natural := 8;
	
	-- *** Not Assigned Generics (default values) ***
	
	-- *** TB Control ***
	signal TbRunning : boolean := True;
	signal NextCase : integer := -1;
	signal ProcessDone : std_logic_vector(0 to 1) := (others => '0');
	constant AllProcessesDone_c : std_logic_vector(0 to 1) := (others => '1');
	constant TbProcNr_inp_c : integer := 0;
	constant TbProcNr_outp_c : integer := 1;
	
	-- *** DUT Signals ***
	signal Clk : std_logic := '1';
	signal Rst : std_logic := '1';
	signal Parallel : std_logic_vector(ChannelCount_g*ChannelWidth_g-1 downto 0) := (others => '0');
	signal ParallelVld : std_logic := '0';
	signal Tdm : std_logic_vector(ChannelWidth_g-1 downto 0) := (others => '0');
	signal TdmVld : std_logic := '0';
	
	-- handwritten
	signal TestCase	: integer := -1;
	signal Channels	: t_aslv8(0 to 2) := (others => (others => '0'));
	
	procedure ExpectChannels(	Values : in t_ainteger(0 to 2)) is
	begin
		wait until rising_edge(Clk) and TdmVld = '1';
		StdlvCompareInt (Values(0), Tdm, "Wrong value Channel 0", false);
		wait until rising_edge(Clk) and TdmVld = '1';
		StdlvCompareInt (Values(1), Tdm, "Wrong value Channel 1", false);
		wait until rising_edge(Clk) and TdmVld = '1';
		StdlvCompareInt (Values(2), Tdm, "Wrong value Channel 2", false);		
	end procedure;
	
begin
	------------------------------------------------------------
	-- DUT Instantiation
	------------------------------------------------------------
	Parallel(ChannelWidth_g*3-1 downto ChannelWidth_g*2) <= Channels(2);
	Parallel(ChannelWidth_g*2-1 downto ChannelWidth_g*1) <= Channels(1);
	Parallel(ChannelWidth_g*1-1 downto ChannelWidth_g*0) <= Channels(0);
	
	i_dut : entity work.psi_common_par_tdm
		generic map (
			ChannelCount_g => ChannelCount_g,
			ChannelWidth_g => ChannelWidth_g
		)
		port map (
			Clk => Clk,
			Rst => Rst,
			Parallel => Parallel,
			ParallelVld => ParallelVld,
			Tdm => Tdm,
			TdmVld => TdmVld
		);
	
	------------------------------------------------------------
	-- Testbench Control !DO NOT EDIT!
	------------------------------------------------------------
	p_tb_control : process
	begin
		wait until Rst = '0';
		wait until ProcessDone = AllProcessesDone_c;
		TbRunning <= false;
		wait;
	end process;
	
	------------------------------------------------------------
	-- Clocks !DO NOT EDIT!
	------------------------------------------------------------
	p_clock_Clk : process
		constant Frequency_c : real := real(100e6);
	begin
		while TbRunning loop
			wait for 0.5*(1 sec)/Frequency_c;
			Clk <= not Clk;
		end loop;
		wait;
	end process;
	
	
	------------------------------------------------------------
	-- Resets
	------------------------------------------------------------
	p_rst_Rst : process
	begin
		wait for 1 us;
		-- Wait for two clk edges to ensure reset is active for at least one edge
		wait until rising_edge(Clk);
		wait until rising_edge(Clk);
		Rst <= '0';
		wait;
	end process;
	
	
	------------------------------------------------------------
	-- Processes
	------------------------------------------------------------
	-- *** inp ***
	p_inp : process
	begin
		-- start of process !DO NOT EDIT
		wait until Rst = '0';
		
		-- *** Samples with much space in between ***
		TestCase <= 0;
		-- First Sample
		wait until rising_edge(Clk);
		Channels(0) <= X"01";
		Channels(1) <= X"11";
		Channels(2) <= X"21";
		ParallelVld <= '1';
		wait until rising_edge(Clk);
		ParallelVld <= '0';
		Channels <= (others => (others => '0'));
		wait for 1 us;
		
		-- Second Sample
		wait until rising_edge(Clk);
		Channels(0) <= X"02";
		Channels(1) <= X"12";
		Channels(2) <= X"22";	
		ParallelVld <= '1';
		wait until rising_edge(Clk);	
		ParallelVld <= '0';
		Channels <= (others => (others => '0'));	
		wait for 1 us;

		-- *** Samples at maximum rate ***
		TestCase <= 1;
		for i in 0 to 5 loop
			wait until rising_edge(Clk);
			Channels(0) <= std_logic_vector(to_unsigned(16#50# + i, ChannelWidth_g));
			Channels(1) <= std_logic_vector(to_unsigned(16#60# + i, ChannelWidth_g));
			Channels(2) <= std_logic_vector(to_unsigned(16#70# + i, ChannelWidth_g));	
			ParallelVld <= '1';
			wait until rising_edge(Clk);
			ParallelVld <= '0';
			Channels <= (others => (others => '0'));
			wait until rising_edge(Clk);
		end loop;
		
		
		-- end of process !DO NOT EDIT!
		ProcessDone(TbProcNr_inp_c) <= '1';
		wait;
	end process;
	
	-- *** outp ***
	p_outp : process
	begin
		-- start of process !DO NOT EDIT
		wait until Rst = '0';
		
		-- *** Samples with much space in between ***
		wait until TestCase = 0;
		-- First Sample
		ExpectChannels((16#01#, 16#11#, 16#21#));
		-- Second Sample
		ExpectChannels((16#02#, 16#12#, 16#22#));
		
		-- *** Samples at maximum rate ***
		wait until TestCase = 1;
		for i in 0 to 5 loop
			ExpectChannels((16#50#+i, 16#60#+i, 16#70#+i));
		end loop;
		
		
		-- end of process !DO NOT EDIT!
		ProcessDone(TbProcNr_outp_c) <= '1';
		wait;
	end process;
	
	
end;