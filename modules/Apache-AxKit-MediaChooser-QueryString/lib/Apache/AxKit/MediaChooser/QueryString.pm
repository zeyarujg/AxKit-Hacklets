# Copyright (C) 2011 by Hansjörg Pehofer
#
# Based on Apache::AxKit::StyleChooser::QueryString
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

package Apache::AxKit::MediaChooser::QueryString;

use strict;
use Apache::Constants qw(OK);

sub handler {
    my $r = shift;

    my %in = $r->args();
    my $key = $r->dir_config('AxMediaChooserQueryStringKey') || 'media';

    if ($in{$key}=~/^(?:screen|handheld|print)$/) {
        $r->notes('preferred_media', $in{$key});
    }
    return OK;
}

1;
__END__

=head1 NAME

Apache::AxKit::MediaChooser::QueryString - Choose media using querystring

=head1 SYNOPSIS

  AxAddPlugin Apache::AxKit::MediaChooser::QueryString

=head1 DESCRIPTION

This module lets you pick a media based on the querystring. 
To use it, simply add this module as an AxKit plugin that 
will be run before main AxKit processing is done.

  AxAddPlugin Apache::AxKit::MediaChooser::QueryString

By default, the key name of the name/value pair is 'media'.
This can be changed by setting the variable AxMediaChooserQueryStringKey
in your httpd.conf:

  PerlSetVar AxMediaChooserQueryStringKey mymedia

Then simply by referencing your xml files as follows:

  http://xml.server.com/myfile.xml?media=printable
  
or

  http://xml.server.com/myfile.xml?mymedia=printable

respectively - you will recieve the alternate mediasheets with title
"printable". See the HTML 4.0 specification for more details on
mediasheet choice.

See the B<AxMediaName> AxKit configuration directive
for more information on how to setup named medias.

=head1 SEE ALSO

AxKit

=cut
