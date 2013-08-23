package Apache::AxKit::Plugin::Locale;

use strict;
use Apache::Constants;
use Apache::Request;
use POSIX qw(setlocale LC_ALL);
# use Data::Dumper;

use vars qw($VERSION);
$VERSION = '0.02';


sub handler {
    my $r   = shift;
    my $cgi = Apache::Request->instance($r);

    my $lfbk = $r->dir_config('AxLocaleFallback');
    my %lmap = $r->dir_config->get('AxLocaleMap');

    return SERVER_ERROR unless (length($lfbk) and length ($lmap{$lfbk})); 


    my $lang = $r->content_languages->[0] || $lfbk;
    $cgi->parms->set( 'request.content_language' => $lang );

    if ( length(setlocale(LC_ALL, $lmap{$lang})) ) {
        $r->register_cleanup(sub { setlocale(LC_ALL, "C"); });
        return OK;
    }
    else {
        warn 'Unable to set Locale "' . $lmap{$lang} . "\"\n";
        return SERVER_ERROR;
    }
}

1;

__END__

=head1 NAME

Apache::AxKit::Plugin::Locale

=head1 SYNOPSIS

  # in httpd.conf or .htaccess
  AxAddPlugin Apache::AxKit::Plugin::Locale
  PerlSetVar AxDefaultLanguage 'de'

=head1 DESCRIPTION

Apache::AxKit::Plugin::Locale reads the content language from
$r->content_languages, makes this information available as param
within XSLT stylesheets (a la Kip Hampton's
Apache::AxKit::Plugin::AddXSLParams::Request) and tries to set the
locale accordingly.

The objective is to offer a clean way to deal language negotiation in
XSLT stylesheets.

=head1 SEE ALSO

AxKit, ...

=head1 BUGS

Names for locales usually don't match the Languages configured in the
server. There probably should be some sort of configurable mapping
between server and installed locales.

For now I simply created the required locales from installed ones:

   localedef -c -f UTF-8 -i de_AT 'de.UTF-8'
   localedef -c -f UTF-8 -i en_US 'en.UTF-8'
   localedef -c -f UTF-8 -i it_IT 'it.UTF-8'

=head1 AUTHOR

Hansjoerg Pehofer, E<lt>hansjoerg.pehofer@uibk.ac.atE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Hansjoerg Pehofer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.1 or,
at your option, any later version of Perl 5 you may have available.


=cut
