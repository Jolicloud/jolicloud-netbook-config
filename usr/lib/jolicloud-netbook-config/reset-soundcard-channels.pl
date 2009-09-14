#!/usr/bin/perl

use Data::Dumper;
use IO::Handle;

my $channel = "";
my $mixer = {};

my $LOGFILE = "/var/log/jolicloud-netbook-config";
my $VERBOSE = 0;
my $DRYRUN = 0;
my $DEBUG = 0;

my $config = {
    "'Master',0" => {    pvolume => "90%",  pswitch => "unmute" },
    "'PCM',0" => {       pvolume => "100%", pswitch => "unmute", },
    "'Headphone',0" => { pvolume => "100%", pswitch => "unmute", },
    "'Speaker',0" => {   pvolume => "100%", pswitch => "unmute", },
    "'PC Beep',0" => {   pvolume => "0%",   pswitch => "mute", },
    "'Internal Mic Boost',0" => { pvolume => "50%", pswitch => "unmute" },
    "'Front Mic Boost',0" => { pvolume => "30%", pswitch => "unmute" },
    "'Mic Jack Mode',0" => { enum => "Mic In" },
    "'Input Source',0" => { cenum => "Front Mic" },
    "'Capture',0" => {   cvolume => "100%", cswitch => "cap", },
    "'Front Mic',0" => { cvolume => "90%",  cswitch => "cap", },
    "'i-Mic',0" => {     cvolume => "90%",  cswitch => "cap", },
    "'Line In',0" => {   cvolume => "90%",  cswitch => "cap", },
};

open( LOG, ">>$LOGFILE" );
STDOUT->fdopen( \*LOG, "w" ) || die $!;

&log( "Begin $0" );

while ( my $arg = shift ) {
    if ( $arg eq "-D" ) {
        $DEBUG = 1;
    }
    elsif ( $arg eq "-d" ) {
        $DRYRUN = 1;
    }
    elsif ( $arg eq "-v" ) {
        $VERBOSE = 1;
    }
}

foreach my $line ( `amixer` ) {
    chomp;
    if ( $line =~ /^Simple mixer control ('.*?',(\d))$/ ) {
        # Skip channels that do not end in 0
        $channel = ( $2 eq "0" ) ? $1 : "";
    }
    elsif ( $channel && $line =~ /^  (.*?): (.*?)$/ ) {
        my ( $key, $val ) = ( $1, $2 );
        if ( ( $key eq "Capabilities" ) ||
             ( $key =~ "Items" ) ) {
            if ( $val =~ s/^'(.*?)'$/$1/ ) {
                $val = [ split( "' '", $val ) ];
            }
            else {
                $val = [ split( " ", $val ) ];
            }
        }
        elsif ( $key eq "Item0" ) {
            $val =~ s/^'(.*?)'$/$1/;
        }
        $mixer->{ $channel }->{ $key } = $val;
    }
}

&log( "Amixer Settings: " . Dumper( $mixer ) );
&log( "Global Config: " . Dumper( $config ) );

# Load any device-specific config

#&log( "Device Config: " . Dumper( $config ) );

while ( ( $channel, $data ) = each %{ $mixer } ) {
    my @sset;

    if ( exists $config->{ $channel } ) {
        my $cfg = $config->{ $channel };

        while ( my ( $capability, $setting ) = each %{ $cfg } ) {
            if ( &isin( $capability, $data->{ 'Capabilities' } ) ) {
                # If we're dealing with an enum or cenum, make sure the
                # setting requested exists in the Items array, otherwise
                # amixer will error out.
                if ( $capability =~ /enum$/ &&
                     ! &isin( $setting, $data->{ 'Items' } ) ) {
                    &log( "WARNING: cannot apply $channel -> $setting" );
                    next;
                }
                push( @sset, qq("$setting") );
            }
        }
    }

    if ( @sset ) {
        my $cmd = "/usr/bin/amixer sset $channel " . join( ' ', @sset );
        print STDERR "$cmd\n" if ( $VERBOSE );
        &log( $cmd );
        # Execute the command. Data returned on STDOUT is relayed to LOG
        print `$cmd` . "\n" if ( ! $DRYRUN );
    }
}

&log( "Finish $0" );
close( LOG );



sub log
{
    my $msg  = shift;
    my @time = localtime;
    $time[ 5 ] += 1900;
    $time[ 4 ] += 1;

    my $time = sprintf "%04d-%02d-%02d %02d:%02d:%02d", reverse @time[ 0..5 ];

    print LOG "$time (RSC) $msg\n";
    if ( $msg =~ /^(WARNING|ERROR)/ ) {
        print STDERR "$time (JNS) $msg\n";
    }
}


sub isin
{
    my ( $needle, $haystack ) = @_;
    return grep( $_ eq $needle, @{ $haystack } );
}

