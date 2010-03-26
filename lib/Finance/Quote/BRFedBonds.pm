#!/usr/bin/perl -w
#
# BRFedBonds.pm
#
# 0.1 - First public release
# by Paulo Schreiner <paulo.schreiner@gmail.com>
#
# Based on USFedBonds.pm by Stephen Langenhoven <langenhoven@users.sourcesforge.net>
#




package Finance::Quote::BRFedBonds;
require 5.004;

use strict;
use vars qw /$VERSION/ ;

use LWP::UserAgent;
use HTTP::Request::Common;
use HTML::TableExtract;
use HTML::Parser;

$VERSION = '1.17' ;

sub methods {
    return (brfedbonds => \&treasury);
}


sub labels {
    my @labels = qw/method source name symbol currency last date isodate nav price/;
    return (brfedbonds => \@labels);
}


sub treasury {

    my $quoter = shift;
    my @symbols = @_;
    my %info;

#     print "[debug]: ", @symbols, "\n";

    return unless @symbols;

    my $url = 'http://www.tesouro.fazenda.gov.br/tesouro_direto/consulta_titulos/consultatitulos.asp';

    my $ua = $quoter->user_agent;
    my $response = $ua->request(GET $url);
    
    $response->content =~ /Atualizado em: <b>([0-9]+)-([0-9]+)-([0-9]+) ([0-9:]+)/;
    my $date = "$2/$1/$3";

    foreach my $symbol (@symbols) {
    		
	    #$response->content =~ /$symbol([^\$]*)\$\s*(([0-9]+)\.)?([0-9]+),([0-9]+)/;
	    if($response->content =~ /$symbol([^\$]*)\$[^\$]*-/ {
			    $info{$symbol, "success"} = 0;
			    $info{$symbol, "errormsg"} = "Parse error";
		}
		else {
	    $response->content =~ /$symbol([^\$]*)\$[^\$-]*\$\s*(([0-9]+)\.)?([0-9]+),([0-9]+)/;
	    

	    my $price = $2 * 1000 + $4 + $5/100;

	    $info{$symbol, "method"} = "treasury";

	    $info{$symbol, "price"} = $price;
	    $info{$symbol, "last"} = $price;
	    $info{$symbol, "symbol"} = $symbol;
	    $info{$symbol, "currency"} = "BRL";
	    $info{$symbol, "date"} = $date;
	    $info{$symbol, "version"} = "0.1";
	    $info{$symbol, "success"} = 1;
    	}

    }

    return wantarray() ? %info : \%info;
}

1;

=head1 NAME

Finance::Quote::BRFedBonds
Get BR Federal Bond (Tesouro Direto) current market value
from http://www.tesouro.fazenda.gov.br/tesouro_direto/consulta_titulos/consultatitulos.asp


=head1 SYNOPSIS

    use Finance::Quote;

    $q = Finance::Quote->new;

    # Don't know anything about failover yet...

=head1 DESCRIPTION

...

=head1 LABELS RETURNED

...

=head1 SEE ALSO

...

Finance::Quote

=head1 AUTHOR
Paulo Schreiner <paulo.schreiner@gmail.com>

=cut

