--
-- VoiceRom.vhd
--
-- Copyright (c) 2006 Mitsutaka Okazaki (brezza@pokipoki.org)
-- All rights reserved.
--
-- Redistribution and use of this source code or any derivative works, are
-- permitted provided that the following conditions are met:
--
-- 1. Redistributions of source code must retain the above copyright notice,
--    this list of conditions and the following disclaimer.
-- 2. Redistributions in binary form must reproduce the above copyright
--    notice, this list of conditions and the following disclaimer in the
--    documentation and/or other materials provided with the distribution.
-- 3. Redistributions may not be sold, nor may they be used in a commercial
--    product or activity without specific prior written permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
-- "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
-- TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
-- PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
-- CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
-- EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
-- PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
-- OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
-- WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
-- OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
-- ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use WORK.VM2413.ALL;

entity VoiceRom is
  port (
    clk    : in std_logic;
    addr : in VOICE_ID_TYPE;
    data  : out VOICE_TYPE
  );
end VoiceRom;

architecture RTL of VoiceRom is

  type VOICE_ARRAY_TYPE is array (VOICE_ID_TYPE'range) of VOICE_VECTOR_TYPE;
  constant voices : VOICE_ARRAY_TYPE := (
--From nesdev.com
--     00 01 02 03 04 05 06 07
--     -----------------------
-- 0 | -- -- -- -- -- -- -- --
-- 1 | 03 21 05 06 B8 81 42 27
-- 2 | 13 41 13 0D D8 D6 23 12
-- 3 | 31 11 08 08 FA 9A 22 02
-- 4 | 31 61 18 07 78 64 30 27
-- 5 | 22 21 1E 06 F0 76 08 28
-- 6 | 02 01 06 00 F0 F2 03 F5
-- 7 | 21 61 1D 07 82 81 16 07
-- 8 | 23 21 1A 17 CF 72 25 17
-- 9 | 15 11 25 00 4F 71 00 11
-- A | 85 01 12 0F 99 A2 40 02
-- B | 07 C1 69 07 F3 F5 A7 12
-- C | 71 23 0D 06 67 75 23 16
-- D | 01 02 D3 05 A3 92 F7 52
-- E | 61 63 0C 00 94 AF 34 06
-- F | 21 72 0D 00 C1 A0 54 16
--Register	Bitfield	Description
--$00	TVSK MMMM	Modulator tremolo (T), vibrato (V), sustain (S), key rate scaling (K), multiplier (M)
--$01	TVSK MMMM	Carrier tremolo (T), vibrato (V), sustain (S), key rate scaling (K), multiplier (M)
--$02	KKOO OOOO	Modulator key level scaling (K), output level (O)
--$03	KK-Q WFFF	Carrier key level scaling (K), unused (-), carrier waveform (Q), modulator waveform (W), feedback (F)
--$04	AAAA DDDD	Modulator attack (A), decay (D)
--$05	AAAA DDDD	Carrier attack (A), decay (D)
--$06	SSSS RRRR	Modulator sustain (S), release (R)
--$07	SSSS RRRR	Carrier sustain (S), release (R)
-- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
  "000000000000000000000000000000000000", -- @0(M)
  "000000000000000000000000000000000000", -- @0(C)
-- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
  "000000110000010101101011100001000010", -- @1(M)
  "001000010000000000001000000100100111", -- @1(C)
-- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
  "000100110001001111011101100000100011", -- @2(M)
  "010000010000000000001101011000010010", -- @2(C)
-- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
  "001100010000100010001111101000100010", -- @3(M)
  "000100010000000000001001101000000010", -- @3(C)
-- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
  "001100010001100001110111100000110000", -- @4(M)
  "011000010000000000000110010000100111", -- @4(C)
-- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
  "001000100001111001101111000000001000", -- @5(M)
  "001000010000000000000111011000101000", -- @5(C)
-- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
  "000000100000011000001111000000000011", -- @6(M)
  "000000010000000000001111001011110101", -- @6(C)
-- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
  "001000010001110101111000001000010110", -- @7(M)
  "011000010000000000001000000100000111", -- @7(C)
-- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
  "001000110001101001111100111100100101", -- @8(M)
  "001000010000000010000111001000010111", -- @8(C)
-- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
  "000101010010010100000100111100000000", -- @9(M)
  "000100010000000000000111000100010001", -- @9(C)
-- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
  "100001010001001011111001100101000000", -- @10(M)
  "000000010000000000001010001000000010", -- @10(C)
-- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
  "000001110110100101111111001110100111", -- @11(M)
  "110000010000000000001111010100010010", -- @11(C)
-- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
  "011100010000110101100110011100100011", -- @12(M)
  "001000110000000000000111010100010110", -- @12(C)
-- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
  "000000011101001101011010001111110111", -- @13(M)
  "000000100000000000001001001001010010", -- @13(C)
-- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
  "011000010000110000001001010000110100", -- @14(M)
  "011000110000000000001010111100000110", -- @14(C)
-- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
  "001000010000110100001100000101010100", -- @15(M)
  "011100100000000000001010000000010110", -- @15(C)

---- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
--  "000000000000000000000000000000000000", -- @0(M)
--  "000000000000000000000000000000000000", -- @0(C)
---- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
--  "011000010001111001111111000000000000", -- @1(M)
--  "011000010000000010000111111100010111", -- @1(C)
---- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
--  "000100110001011111101111111100100011", -- @2(M)
--  "010000010000000000001111111100010011", -- @2(C)
---- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
--  "001000111001101001001010001111110000", -- @3(M)
--  "000000010000000000001111010000100011", -- @3(C)
---- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
--  "000100010000111001111111101001110000", -- @4(M)
--  "011000010000000000000110010000010111", -- @4(C)
---- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
--  "001000100001111001101111000000000000", -- @5(M)
--  "001000010000000000000111011000101000", -- @5(C)
---- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
--  "001000010001011001011111000000000000", -- @6(M)
--  "001000100000000000000111000100011000", -- @6(C)
---- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
--  "001000010001110101111000001000010000", -- @7(M)
--  "011000010000000000001000000000000111", -- @7(C)
---- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
--  "001000110010110101101001000000000000", -- @8(M)
--  "001000010000000010001001000000000111", -- @8(C)
---- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
--  "001000010001101101100110010000010000", -- @9(M)
--  "001000010000000000000110010100010111", -- @9(C)
---- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
--  "001000010000101110101000010101110000", -- @10(M)
--  "001000010000000010001010000000000111", -- @10(C)
---- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
--  "001000111000001100001111111100010000", -- @11(M)
--  "000000010000000010001011000000000100", -- @11(C)
---- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
--  "100101110010000001111111111100100010", -- @12(M)
--  "110000010000000000001111111100010010", -- @12(C)
---- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
--  "011000010000110001011101001001000000", -- @13(M)
--  "000000000000000000001111011001000011", -- @13(C)
---- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
--  "000000010101011000111111010000000011", -- @14(M)
--  "000000010000000000001111000000000010", -- @14(C)
---- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
--  "001000011000100100111111000111110000", -- @15(M)
--  "010000010000000000001111010000100011", -- @15(C)
-- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
  "000001110001011000001101111111111111", -- BD(M)
  "001000010000000000001111100011111000", -- BD(C)
-- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
  "001100010000000000001111011111110111", -- HH
  "001100100000000000001111011111110111", -- SD
-- APEK<ML>KL< TL >W<F><AR><DR><SL><RR>
  "001001010000000000001111100011111000", -- TOM
  "000000010000000000001101110001010101"  -- CYM
);

begin

  process (clk)

  begin

    if clk'event and clk = '1' then
      data <= CONV_VOICE(voices(addr));
    end if;

  end process;

end RTL;