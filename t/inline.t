#!/usr/bin/env perl

use Test::Most tests => 1;

use Modern::Perl;

use Module::Load;
use Renard::API::Cairo;

subtest "Testing Cairo" => sub {
	eval { load 'Inline::C' } or do {
		my $error = $@;
		plan skip_all => "Inline::C not installed" if $error;
	};

	Inline->import( with => qw(Renard::API::Cairo) );

	my @sz = (25, 50);
	my $surface = Cairo::ImageSurface->create ('argb32', @sz);

	subtest 'Typemap for cairo_surface_t* works' => sub {
		Inline->bind( C => q|
			int width(cairo_surface_t* surface) {
				return cairo_image_surface_get_width(surface);
			}

			int height(cairo_surface_t* surface) {
				return cairo_image_surface_get_height(surface);
			}
		|, ENABLE => AUTOWRAP => );

		is( width($surface), $sz[0], 'Got width');
		is( height($surface), $sz[1], 'Got height');
	};

};

done_testing;
