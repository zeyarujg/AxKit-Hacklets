# Copyright (C) 2011 by Hansjörg Pehofer
#
# based on Apache::AxKit::Language::LibXSLT.pm:
# Copyright 2001-2005 The Apache Software Foundation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


package Apache::AxKit::Language::HTML5Writer;

use strict;
use vars qw/@ISA $VERSION %DEPENDS/;
use HTML::HTML5::Writer;
use XML::LibXML;
use Apache;
use Apache::Request;
use Apache::AxKit::Language;
use Apache::AxKit::Provider;
use Apache::AxKit::LibXMLSupport;
use File::Basename qw(dirname);

@ISA = 'Apache::AxKit::Language';

$VERSION = 1.0; # this fixes a CPAN.pm bug. Bah!

sub handler {
    my $class = shift;
    my ($r, $xml, $style, $last_in_chain) = @_;

    my ($xmlstring, $xml_doc);

    AxKit::Debug(7, "[HTML5-Writer] getting the XML");

    if (my $dom = $r->pnotes('dom_tree')) {
        $xml_doc = $dom;
        delete $r->pnotes()->{'dom_tree'};
    }
    else {
        $xmlstring = $r->pnotes('xml_string');
    }

    my $parser = XML::LibXML->new();
    $parser->expand_entities(1);
    local($XML::LibXML::match_cb, $XML::LibXML::open_cb,
          $XML::LibXML::read_cb, $XML::LibXML::close_cb);
    Apache::AxKit::LibXMLSupport->reset();

    local $Apache::AxKit::LibXMLSupport::provider_cb = 
        sub {
            my $r = shift;
            my $provider = Apache::AxKit::Provider->new_content_provider($r);
            add_depends($provider->key());
            return $provider;
        };

    if (!$xml_doc && !$xmlstring) {
        $xml_doc = $xml->get_dom();
    } 
    elsif ($xmlstring) {
        $xml_doc = $parser->parse_string($xmlstring, $r->uri());
    }

    $xml_doc->process_xinclude();

    AxKit::Debug(7, "[HTML5-Writer] performing transformation");

    my $writer = HTML::HTML5::Writer->new(polyglot => 1);
    my $results = $writer->document($xml_doc);

    AxKit::Debug(7, "[HTML5-Writer] transformation finished, creating $results");

    if ($last_in_chain) {
        AxKit::Debug(8, "[HTML5-Writer] outputting to \$r");
        $r->content_type('text/html; charset=utf-8');
        $r->print( $results );
    }

    AxKit::Debug(7, "[HTML5-Writer] storing results in pnotes(dom_tree) ($r)");
    $r->pnotes('dom_tree', $results);

    return Apache::Constants::OK;

}

1;
