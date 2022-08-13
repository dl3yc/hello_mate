 -- blinky_tb.vhd - TLE for blinken lights
 --
 -- Implements the top level entity of the K.I.T.T. style led bar
 -- on GateMate Evaluation Board where LEDs and reset button are inverted.
 --
 -- Copyright (c) 2022, Sebastian Weiss <dl3yc@darc.de>
 -- All rights reserved.
 -- 
 -- This source code is licensed under the BSD-style license found in the
 -- LICENSE file in the root directory of this source tree. 
 
library ieee, std;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.helper_pkg.all;

entity blinky_syn is
	port (
		clk		: in std_logic;
		rst_n		: in std_logic;

		led_n	: out std_logic_vector(7 downto 0)
	);
end entity blinky_syn;

architecture rtl of blinky_syn is
	signal led : std_logic_vector(7 downto 0);
begin

	blink : entity work.blinky
		generic map(
			led_width => 8,
			clk_prescaler => 1000000	
		)
		port map(
			clk => clk,
			rst => not rst_n,
			led => led
		);
	led_n <= not led;
end architecture rtl;
