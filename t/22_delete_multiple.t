use strict;
use warnings;

use Test;
use Net::IMAP::Simple;

plan tests => our $tests = 4;

sub run_tests {
    open INFC, ">>", "informal-imap-client-dump.log" or die $!;

    my $imap = Net::IMAP::Simple->new('localhost:8000', debug=>\*INFC, use_ssl=>1)
        or die "\nconnect failed: $Net::IMAP::Simple::errstr\n";

    $imap->login(qw(working login));
    my $nm = $imap->select('INBOX')
        or die " failure selecting INBOX: " . $imap->errstr . "\n";

    ok( $imap->select("INBOX")+0, 0 );

    $imap->put( INBOX => "Subject: test-$_\n\ntest-$_", '\Seen' ) for 1 .. 10;
    $imap->delete( "3:5" ) or die $imap->errstr;
    my @e = $imap->expunge_mailbox;
    ok( not $imap->waserr );
    ok( "@e", "3 4 5" );

    ok( $imap->last, 7 );
}   

do "t/test_server.pm" or die "error starting imap server: $!$@";

