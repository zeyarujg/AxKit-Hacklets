AxKit-Hacklets
=================================

Obsolete stuff for dead software. These are little Apache-1.3/mod_perl1 era
solutions to *very* specific itches, collected here solely for (my) reverence.
YMMV.

Modules
-------

* Apache-AxKit-Language-HTML5Writer

    An Experiment with HTML::HTML5Writer as serializer.

* Apache-AxKit-MediaChooser-Handhelds

    Set media to »handheld« based on the user-agent header.

* Apache-AxKit-MediaChooser-QueryString

    Set media based on a CGI parameter.
 
* Apache-AxKit-Plugin-Locale

    Set the Locale for a given request based on language-negotiation. 

* Apache-AxKit-Plugin-NotFoundIfPathInfo

    (See http://search.cpan.org/~zeya/)

* Apache-AxKit-Plugin-QueryStringCacheRegexp

    (See http://search.cpan.org/~zeya/)

* Apache-LangPrefCookie

    (See http://search.cpan.org/~zeya/)


Patches
-------

* error-status.patch

    Have AxKit serving its ErrorPage/Stacktraces with a 500/Internal Server
    Error instead of 200/OK. 

* XML-Filter-GenericChunk.patch

    A NYTProf-guided attempt to make XML::Filter::GenericChunk a little bit faster.

* xmlsave.html5.patch (libxml2-2.9.1/xmlsave.c)

    An experimental patch for libxml2 to allow HTML5 Polyglot Markup
    serialisation.

    The patch extends the serialisers’ existing XHTML-compatibility routines
    i.e. it checks for the 'about:legacy-compat' SystemID and the
    XHTML-namespace. The six new void HTML5 elements were added. (HTML5 defines
    the following elements as empty: area, base, br, col, embed, hr, img, input,
    keygen, link, meta, param, source, track, wbr; see "3.6.1 Void elements" in:
    http://dev.w3.org/html5/html-xhtml-author-guide/#empty-elements)

