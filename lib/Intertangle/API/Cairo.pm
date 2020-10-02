use Renard::Incunabula::Common::Setup;
package Intertangle::API::Cairo;
# ABSTRACT: Helper library for the Cairo graphics library

use Cairo;
use List::MoreUtils qw(zip);

=method Inline

  use Inline C with => qw(Intertangle::API::Cairo);

Returns the flags needed to configure L<Inline::C> for using the
L<Cairo> XS API.

=cut
sub Inline  {
	return unless $_[-1] eq 'C';

	require ExtUtils::Depends;
	my $ref = ExtUtils::Depends::load('Cairo');

	my $config = +{ map { uc($_) => $ref->{$_} } qw(inc libs typemaps) };

	# Set CCFLAGSEX to the value of INC directly. This is to get around some
	# shell parsing / quoting bug that causes INC to quote parts that
	# should not be quoted.
	$config->{CCFLAGSEX} = delete $config->{INC};

	$config->{LIBS} = join " ", qw(:nosearch), $config->{LIBS}, qw(:search);

	# Add the Cairo.pm dynamic library to access the cairo-perl symbols.
	# This is usually handled automatically by simply loading Cairo.pm via
	# DynaLoader, but on Windows, it must be explicitly linked.
	if( $^O eq 'MSWin32') {
		my %dl_module_to_so = zip( @DynaLoader::dl_modules, @DynaLoader::dl_shared_objects );
		$config->{MYEXTLIB} = $dl_module_to_so{Cairo};
	}

	$config->{AUTO_INCLUDE} = <<C;
#include <cairo-perl.h>
C

	$config;
}

package Cairo::Matrix {
	# <https://cairographics.org/manual/cairo-cairo-matrix-t.html>
	use Renard::Incunabula::Common::Setup;

	use Config;

	# struct elements
	use constant NUM_OF_ELEMENTS => 6;

	# bytes
	use constant SIZEOF_DOUBLE   => $Config{doublesize};

	method _unpack_struct() {
		( unpack 'd'.(NUM_OF_ELEMENTS), unpack 'P'.(NUM_OF_ELEMENTS*SIZEOF_DOUBLE), pack 'J', $$self )
	}

=method Cairo::Matrix::to_HashRef

Returns a C<HashRef> with the keys C<xx yx xy yy x0 y0> that represent the
matrix components.

=cut
	method to_HashRef() {
		my @fields = qw(xx yx xy yy x0 y0);
		my @data = $self->_unpack_struct;

		+{ map { $fields[$_] => $data[$_] } 0..@fields-1 };
	}

}

1;
=head1 SEE ALSO



=cut
