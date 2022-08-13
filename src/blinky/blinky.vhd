 -- blinky.vhd - blinken lights
 --
 -- implements K.I.T.T. style led bar
 --
 -- Copyright (c) 2022, Sebastian Weiss <dl3yc@darc.de>
 -- All rights reserved.
 -- 
 -- This source code is licensed under the BSD-style license found in the
 -- LICENSE file in the root directory of this source tree. 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.helper_pkg.all;

entity blinky is
	generic (
		led_width		: positive;
		clk_prescaler	: positive
	);
	port (
		clk		: in std_logic;
		rst		: in std_logic;

		led		: out std_logic_vector(led_width-1 downto 0)
	);
end entity blinky;

architecture impl of blinky is
	constant clk_cnt_len	: positive := ceillog2(clk_prescaler-1);
	signal clk_cnt			: unsigned(clk_cnt_len-1 downto 0);
	signal clk_en			: std_logic;
	signal led_dir			: std_logic;
	signal led_bar			: std_logic_vector(led_width-1 downto 0);
begin

	clk_gen : process (clk, rst)
	begin
		if rst = '1' then
			clk_en <= '0';
			clk_cnt <= (others => '0');
		elsif rising_edge(clk) then
			clk_en <= '0';
			clk_cnt <= clk_cnt + 1;
			if clk_cnt = clk_prescaler-1 then
				clk_en <= '1';
				clk_cnt <= (others => '0');
			end if;
		end if;
	end process clk_gen;

	led_shift : process (clk, rst)
	begin
		if rst = '1' then
			led_bar <= (others => '0');
			led_bar(0) <= '1';
			led_dir <= '0';
		elsif rising_edge(clk) then
			if clk_en = '1' then
				if led_dir = '1' then
					-- left shift
					led_bar(led_width-2 downto 0) <= led_bar(led_width-1 downto 1);
					led_bar(led_width-1) <= '0';
					if led_bar(1) = '1' then
						led_dir <= '0';
					end if;
				else
					-- right shift
					led_bar(led_width-1 downto 1) <= led_bar(led_width-2 downto 0);
					led_bar(0) <= '0';
					if led_bar(led_width-2) = '1' then
						led_dir <= '1';
					end if;
				end if;
			end if;
		end if;
	end process led_shift;

	led <= led_bar;
end architecture impl;
