use Renard::Incunabula::Common::Setup;
package Renard::API::Cairo;
# ABSTRACT: Helper library for the Cairo graphics library

use Cairo;

package Cairo::Matrix {
	use Renard::Incunabula::Common::Setup;

	method _unpack_struct() {
		( unpack 'd6', unpack 'P48', pack 'J', $$self )
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

L<Repository information|http://project-renard.github.io/doc/development/repo/p5-Renard-API-Cairo/>

=cut
