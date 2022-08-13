 -- helper_pkg.vhd - helper package with convenient functions
 --
 -- Copyright (c) 2022, Sebastian Weiss <dl3yc@darc.de>
 -- All rights reserved.
 -- 
 -- This source code is licensed under the BSD-style license found in the
 -- LICENSE file in the root directory of this source tree. 

library ieee, std;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_float_types.all;
use ieee.fixed_pkg.all;
use ieee.math_real.all;
use std.textio.all;

package helper_pkg is
	function max (
		constant left_index     : INTEGER;  -- integer portion
		constant right_index    : INTEGER)  -- size of fraction
	return integer;

	function maxval (
		constant left_index     : INTEGER;  -- integer portion
		constant right_index    : INTEGER)  -- size of fraction
	return real;
	
	function maxval (
		constant left_index     : INTEGER;  -- integer portion
		constant right_index    : INTEGER)  -- size of fraction
	return UNRESOLVED_sfixed;

	function minval (
		constant left_index     : INTEGER;  -- integer portion
		constant right_index    : INTEGER)  -- size of fraction
	return UNRESOLVED_sfixed;

	function trunc (
		arg			: UNRESOLVED_sfixed;  -- input
		size_res	: UNRESOLVED_sfixed)  -- for size only
	return UNRESOLVED_sfixed;

	function trunc (
		arg			: UNRESOLVED_ufixed;  -- input
		size_res	: UNRESOLVED_ufixed)  -- for size only
	return UNRESOLVED_ufixed;

	function trunc (
		arg			: UNRESOLVED_sfixed;  -- input
		constant left_index     : INTEGER;  -- integer portion
		constant right_index    : INTEGER)  -- size of fraction
	return UNRESOLVED_sfixed;

	function trunc (
		arg			: UNRESOLVED_ufixed;  -- input
		constant left_index     : INTEGER;  -- integer portion
		constant right_index    : INTEGER)  -- size of fraction
	return UNRESOLVED_ufixed;

	function to_signed_trunc (
		arg                     : UNRESOLVED_sfixed;  -- fixed point input
		constant size           : NATURAL)            -- length of output
	return UNRESOLVED_SIGNED;

	function to_signed_trunc (
		arg                     : UNRESOLVED_sfixed;  -- fixed point input
		size_res                : UNRESOLVED_SIGNED)  -- used for length of output
	return UNRESOLVED_SIGNED;

	function to_sfixed_trunc (
		arg                     : REAL;     -- real
		constant left_index     : INTEGER;  -- left index (high index)
		constant right_index    : INTEGER)  -- right index
	return UNRESOLVED_sfixed;

	function log2 (arg: integer)
	return integer;

	function ceillog2 (arg: integer)
	return integer;

	function floor (arg: integer; div: integer)
	return integer;

	function ceil (divisor : integer; divident: integer)
	return integer;

	function even (arg : integer)
	return boolean;

	function read_real_vector(
		file f : text;
		len : natural)
	return real_vector;
end;

package body helper_pkg is
	function max (
		constant left_index     : INTEGER;  -- integer portion
		constant right_index    : INTEGER)  -- size of fraction
	return integer
	is
	begin
		if left_index > right_index then
			return left_index;
		else
			return right_index;
		end if;
	end function max;

	function maxval (
		constant left_index     : INTEGER;  -- integer portion
		constant right_index    : INTEGER)  -- size of fraction
	return real
	is
	begin
		return 2.0**left_index - 2.0**right_index;
	end function maxval;

	function maxval (
		constant left_index     : INTEGER;  -- integer portion
		constant right_index    : INTEGER)  -- size of fraction
	return UNRESOLVED_sfixed
	is
		variable ret : sfixed(left_index downto right_index);
	begin
		ret(left_index) := '0';
		ret(left_index-1 downto right_index) := (others => '1');
		return ret;
	end function maxval;

	function minval (
		constant left_index     : INTEGER;  -- integer portion
		constant right_index    : INTEGER)  -- size of fraction
	return UNRESOLVED_sfixed
	is
		variable ret : sfixed(left_index downto right_index);
	begin
		ret(left_index) := '1';
		ret(left_index-1 downto right_index+1) := (others => '0');
		ret(right_index) := '1';
		return ret;
	end function minval;

	function trunc (
		arg			: UNRESOLVED_sfixed;  -- input
		size_res	: UNRESOLVED_sfixed )
		return UNRESOLVED_sfixed
	is
		constant overflow_style : fixed_overflow_style_type := ieee.fixed_float_types.fixed_wrap;
		constant round_style    : fixed_round_style_type    := ieee.fixed_float_types.fixed_truncate;
	begin
		return resize(arg, size_res, overflow_style, round_style);
	end function trunc;
	function trunc (
		arg			: UNRESOLVED_ufixed;  -- input
		size_res	: UNRESOLVED_ufixed )
		return UNRESOLVED_ufixed
	is
		constant overflow_style : fixed_overflow_style_type := ieee.fixed_float_types.fixed_wrap;
		constant round_style    : fixed_round_style_type    := ieee.fixed_float_types.fixed_truncate;
	begin
		return resize(arg, size_res, overflow_style, round_style);
	end function trunc;
	function trunc (
		arg			: UNRESOLVED_sfixed;  -- input
		constant left_index     : INTEGER;  -- integer portion
		constant right_index    : INTEGER)  -- size of fraction
		return UNRESOLVED_sfixed
	is
		constant overflow_style : fixed_overflow_style_type := ieee.fixed_float_types.fixed_wrap;
		constant round_style    : fixed_round_style_type    := ieee.fixed_float_types.fixed_truncate;
	begin
		return resize(arg, left_index, right_index, overflow_style, round_style);
	end function trunc;
	function trunc (
		arg			: UNRESOLVED_ufixed;  -- input
		constant left_index     : INTEGER;  -- integer portion
		constant right_index    : INTEGER)  -- size of fraction
		return UNRESOLVED_ufixed
	is
		constant overflow_style : fixed_overflow_style_type := ieee.fixed_float_types.fixed_wrap;
		constant round_style    : fixed_round_style_type    := ieee.fixed_float_types.fixed_truncate;
	begin
		return resize(arg, left_index, right_index, overflow_style, round_style);

	end function trunc;

	-- Type convert an "sfixed" into a "signed", used internally
	function to_s (
		arg : UNRESOLVED_sfixed)            -- fp vector
		return UNRESOLVED_SIGNED
	is
		subtype t is UNRESOLVED_SIGNED(arg'high - arg'low downto 0);
		variable slv : t;
	begin  -- function to_s
		slv := t(arg);
		return slv;
	end function to_s;

	function to_signed_trunc (
	arg                     : UNRESOLVED_sfixed;  -- sfixed point input
	constant size           : NATURAL)            -- length of output
    return UNRESOLVED_SIGNED is
	begin
	return to_s(trunc  (arg => arg,
						left_index => size-1,
						right_index => 0));
	end function to_signed_trunc;

	function to_signed_trunc (
	arg                     : UNRESOLVED_sfixed;  -- sfixed point input
	size_res                : UNRESOLVED_SIGNED)  -- used for length of output
	return UNRESOLVED_SIGNED is
	begin
	return to_signed_trunc (arg => arg,
							size => size_res'length);
	end function to_signed_trunc;

	function to_sfixed_trunc (
	arg                     : REAL;     -- real
	constant left_index     : INTEGER;  -- left index (high index)
	constant right_index    : INTEGER)  -- right index
	return UNRESOLVED_sfixed is
		constant overflow_style : fixed_overflow_style_type := ieee.fixed_float_types.fixed_wrap;
		constant round_style    : fixed_round_style_type    := ieee.fixed_float_types.fixed_truncate;
	begin
		return to_sfixed(arg, left_index, right_index, overflow_style, round_style, 3);
	end function to_sfixed_trunc;

	function log2 (arg: integer)
	return integer is
	begin
		return integer(floor(log2(real(arg))));
	end function log2;

	function ceillog2 (arg: integer)
	return integer is
	begin
		return integer(ceil(log2(real(arg))));
	end function ceillog2;

	function ceil (divisor : integer; divident: integer)
	return integer is
	begin
		return integer(ceil(real(divisor)/real(divident)));
	end function ceil;

	function even (arg : integer)
	return boolean is
	begin
		return arg = (arg/2)*2;
	end function even;

	function floor (arg: integer; div: integer)
	return integer is
	begin
		return integer(floor(real(arg)/real(div)));
	end function floor;

	function read_real_vector(file f : text; len : natural) return real_vector is
		variable l : line;
		variable ret : real_vector(0 to len-1) := (others => 0.0);
	begin
		for i in 0 to len-1 loop
			readline(f, l);
			read(l, ret(i));
		end loop;
		return ret;
	end function read_real_vector;
end package body helper_pkg;