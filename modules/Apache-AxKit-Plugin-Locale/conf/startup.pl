# some XSLT-fx to help i18n.

use POSIX qw(setlocale strftime LC_ALL);
use Locale::Messages qw(:locale_h bind_textdomain_filter turn_utf_8_on);

BEGIN {
    textdomain( 'bla' );
    bindtextdomain( 'bla', '/foo/bar/gonk/locale-data' );
    bind_textdomain_filter( 'uniweb', \&turn_utf_8_on );
    bind_textdomain_codeset( 'uniweb', 'utf-8' );
}

foreach my $function (qw(gettext ngettext pgettext npgettext strftime)) {
    XML::LibXSLT->register_function(
        'http://search.cpan.org/dist/libintl-perl#NS',
        $function,
        \&{$function} );
}

XML::LibXSLT->register_function(
    'http://search.cpan.org/dist/libintl-perl#NS',
    'ngettextf',
    sub{ my ($msgid, $msgid_plural, $count) = @_;
         sprintf( ngettext($msgid, $msgid_plural, $count), $count);
    }
);

XML::LibXSLT->register_function(
    'http://search.cpan.org/dist/libintl-perl#NS',
    'npgettextf',
    sub{ my ($msgctxt, $msgid, $msgid_plural, $count) = @_;
         sprintf( npgettext($msgctxt, $msgid, $msgid_plural, $count), $count);
    }
);

# use Time::Piece;

# XML::LibXSLT->register_function(
#     'http://search.cpan.org/dist/libintl-perl#NS',
#     'strfisotime',
#     sub{ my ($format, $isotimestamp) = @_;
#          Time::Piece->strptime($isotimestamp, '%Y-%m-%dT%H:%M:%S')->strftime( $format );
#     }
# );
