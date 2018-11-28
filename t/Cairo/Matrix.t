#!/usr/bin/env perl

use Test::Most tests => 1;
use Renard::Incunabula::Common::Setup;
use Renard::Incunabula::API::Cairo;

subtest "to_HashRef" => sub {
	subtest "scale" => sub {
		my $matrix = Cairo::Matrix->init_scale(2, 3);
		is_deeply $matrix->to_HashRef,
			{ xx => 2, yy => 3, yx => 0, xy => 0, x0 => 0, y0 => 0, }, 'got the right values';
	};

	subtest "translate" => sub {
		my $matrix = Cairo::Matrix->init_translate(4, 8);
		is_deeply $matrix->to_HashRef,
			{ xx => 1, yy => 1, yx => 0, xy => 0, x0 => 4, y0 => 8, }, 'got the right values';
	};
};

done_testing;
