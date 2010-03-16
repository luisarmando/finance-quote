#!/usr/bin/perl -w
#
#
# BancoBrasil.pm
#
# 0.1 - First public release
# by Paulo Schreiner <paulo.schreiner@gmail.com>
#
# Based on USFedBonds.pm by Stephen Langenhoven <langenhoven@users.sourcesforge.net>
#


package Finance::Quote::BancoBrasil;
require 5.004;

use strict;
use vars qw /$VERSION/ ;

use LWP::UserAgent;
use HTTP::Request::Common;
use HTML::TableExtract;
use HTML::Parser;

$VERSION = '1.17' ;

sub methods {
    return (bancodobrasil => \&bb);
}


sub labels {
    my @labels = qw/method source name symbol currency last date isodate nav price/;
    return (bancodobrasil => \@labels);
}


sub bb {

    my $quoter = shift;
    my @symbols = @_;
    my %info;

#     print "[debug]: ", @symbols, "\n";

    return unless @symbols;


    my $ua = $quoter->user_agent;
    

    foreach my $symbol (@symbols) {

	    my $snum = 0;
	    if($symbol eq "BBPetrobras") {
		    $snum = 55;
		}
		elsif ($symbol eq "BBVale") {
			$snum = 155;
		}

	    my $url = "http://www21.bb.com.br/portalbb/cotaFundos/GFI9,2,001.bbx?tipo=5&fundo=$snum";
	    my $response = $ua->request(GET $url);
	    $response->content =~ /<td>([0-9]+)\.([0-9]+)\.([0-9]+)[^0-9]*([0-9]+),([0-9]+)<\/td>/;
#	    $response->content =~ /($symbol)/;
	    # print "$2 $3 $4 $5\n";

	    my $price = "$4.$5";
	    my $date = "$2/$1/$3";
	    #print "$price\n";

	    $info{$symbol, "method"} = "bancodobrasil";

	    #print "[debug]: (Month): ", $issuemonth, " Redemption Value ", $redemptionvalues[$issuemonth - 1];
	    $info{$symbol, "price"} = $price;
	    $info{$symbol, "last"} = $price;
	    $info{$symbol, "symbol"} = $symbol;
	    $info{$symbol, "currency"} = "BRL";
	    #$info{$symbol, "source"} = "BLA";
	    $info{$symbol, "date"} = $date;
	    $info{$symbol, "version"} = "0.1";
	    $info{$symbol, "success"} = 1;


    }

    return wantarray() ? %info : \%info;
}

1;

=head1 NAME

Finance::Quote::BancoBrasil

Get values of investment fonds in brazilian bank
Banco do Brasil.

=head1 SYNOPSIS

    use Finance::Quote;

    $q = Finance::Quote->new;

    # Don't know anything about failover yet...

=head1 DESCRIPTION


=head1 LABELS RETURNED

...

=head1 SEE ALSO


Finance::Quote

=head1 AUTHOR

=cut

