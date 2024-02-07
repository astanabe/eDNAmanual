#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use open ':encoding(utf8)';
use open ':std';
while (<>) {
	s/([\p{Han}\p{Hiragana}\p{Katakana}]+"\},\{"t":"Space"\},\{"t":"Str","c":")\&("\},\{"t":"Space"\},\{"t":"Str","c":"[\p{Han}\p{Hiragana}\p{Katakana}]+)/$1・$2/g;
	s/([\p{Han}\p{Hiragana}\p{Katakana}]+),("\},\{"t":"Space"\},\{"t":"Str","c":"[\p{Han}\p{Hiragana}\p{Katakana}]+),?/$1$2/g;
	s/([\p{Han}\p{Hiragana}\p{Katakana}]+)"\},\{"t":"Space"\},\{"t":"Emph","c":\[\{"t":"Str","c":"et"\},\{"t":"Space"\},\{"t":"Str","c":"al."\}\]\}/$1ほか/g;
	s/\{"t":"Emph","c":\[(\{"t":"Str","c":"[\p{Han}\p{Hiragana}\p{Katakana}\p{N}]+"\})\]\}/$1/g;
	print;
}
