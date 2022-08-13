 -- blinky_tb.vhd - testbench for blinken lights
 --
 -- Implements K.I.T.T. style led bar
 --
 -- Copyright (c) 2022, Sebastian Weiss <dl3yc@darc.de>
 -- All rights reserved.
 -- 
 -- This source code is licensed under the BSD-style license found in the
 -- LICENSE file in the root directory of this source tree. 

library ieee, std;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.helper_pkg.all;

entity blinky_tb is
end entity blinky_tb;

architecture sim of blinky_tb is
	constant clk_freq : real := 10.0e6;
	constant period_time : time := integer(round(1.0 / (clk_freq * 2.0) * 1.0e12)) * 1 ps;
	signal clk : std_logic := '0';
	signal rst : std_logic := '1';
begin

	clk <= not clk after period_time;
	rst <= '0' after 200 ns;

	dut : entity work.blinky
		generic map(
			led_width => 8,
			clk_prescaler => 1000		
		)
		port map(
			clk => clk,
			rst => rst
		);
end architecture sim;
