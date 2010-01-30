#!/usr/bin/perl -w

# Copyright (c) 2010 by Brian Manning <elspicyjack at gmail dot com>
# PLEASE DO NOT E-MAIL THE AUTHOR WITH ISSUES; the proper venue for issues
# with this script is the Streambake mailing list:
# streambake@googlecode.com / http://groups.google.com/group/streambake

# TODO
# - log format could look something like:
# filename
# time - opening file
# time - updating metadata
# time - closing file
# - simple config file format
# name: value
# name = value
# - maybe use Getopt::Long to parse config info from the config file that's
# read into a $scalar

=pod

=head1 NAME

B<simplebake.pl> - Using a list of MP3/OGG files, stream those files to an
Icecast server.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 DESCRIPTION

B<simplebake.pl> is meant to be used as a quick testing script to verify that
all of the correct C libraries and Perl modules needed to stream audio via an
Icecast server are installed, and that all of the Icecast login information
provided to the script is valid.  The script can also be used for as a simple
script for streaming a list of files on a local filesystem.  The script aims
to use as few non-core Perl modules as possible, so that it will run with any
modern (5.8-ish and newer) Perl installation with no extra libraries beyond
L<Shout> installed.

=cut

######################
# Simplebake::Server #
######################
package Simplebake::Server;
use strict;
use warnings;

sub new {
    my $class = shift;
    my %args = @_;

    my $self = bless ({
        _server         => q(localhost),
        _server_port    => q(8000),
        _server_user    => q(anonymous),
        _server_pass    => q(password),
        _mountpoint     => q(default),
    }, $class);

} # sub new

######################
# Simplebake::Logger #
######################
package Simplebake::Logger;
use strict;
use warnings;
use POSIX qw(strftime)

sub new {
    my $class = shift;
    my $logfile = shift;

    my $self = bless ({}, $class);
    
    if ( defined $logfile ) {
        open (LOG, qq( > $logfile)) || die qq(Can't open logfile $logfile : $!);
        $self->{_OUT} = *LOG;
    } else {
        $self->{_OUT} = *STDOUT;
    } # if ( defined $logfile )

} # sub new

sub log {
    my $self = shift;
    my $msg = shift;

    print $self->{_OUT} $msg . qq(\n);
} # sub log

sub timelog {
    my $self = shift
    my $msg = shift;
    my $timestamp = POSIX::strftime( q(%c), localtime() );

    print $self->{_OUT} $timestamp . q(: ) . $msg . qq(\n);
} # sub timelog

################
# package main #
################
package main;
use strict;
use warnings;

use Getopt::Long;
use Shout;
use bytes;

my $conn = new Shout;
# XXX can go into the server object
# default connection parameters

    
    my $parser = Getopt::Long::Parser->new();

    $parser->getoptions(
        q(verbose|v)            => \$VERBOSE,
        q(help|h)               => \&ShowHelp,
        q(server-port|p=s)      => \@indir,
        q(server|s=s)           => \$outdir,
        q(filelist|f=s)         => \$filelist,
    ); # $parser->getoptions

=head1 SYNOPSIS

 -v|--verbose       Verbose script execution
 -h|--help          Shows this help text
 -c|--config        Configuration file to use for script options
 -l|--logfile       Logfile to use for script output; default is STDOUT
 -s|--server-port   Server hostname/IP address to connect to
 -p|--port          Server server_port number to connect to
 -f|--filelist      List of MP3/OGG files to stream

Example usage:

 simplebake.pl --server_port 7767 --server stream.example.com \
    --filelist /path/to/mp3-ogg.txt

You can generate filelists with something like this on *NIX:

 find /path/to/your/files -name "*.mp3" > output_filelist.txt

Configuration file syntax:

 server_port: 7767
 server: stream.example.com
 filelist: /path/to/mp3-ogg.txt

=cut

my $icepass;
if ( exists $ENV{ICECAST_SOURCE_PASS} ) {
    $icepass = $ENV{ICECAST_SOURCE_PASS};
} else {
    warn qq(WARNING: using default password of 'hackme';\n);
    warn qq(WARNING: this is probably not what you want\n);
    warn qq(WARNING: missing 'ICECAST_SOURCE_PASS' in your environment\n);
    $icepass = q(hackme);
} # if ( exists $ENV{ICECAST_SOURCE_PASS} ) 

# setup all the params
$conn->host($server);
$conn->port($server_port);
$conn->mount($mountpoint);
# XXX can go into the server object
$conn->name(q(Spicyjack's Vault));
$conn->url(q(http://stream.portaboom.com:7767/vault));
$conn->description(q(Created with 'Streambake'...));
$conn->user($user);
$conn->password($icepass);
$conn->public(0);
$conn->format(SHOUT_FORMAT_MP3);
$conn->protocol(SHOUT_PROTOCOL_HTTP);
$conn->set_audio_info(SHOUT_AI_BITRATE => 256, SHOUT_AI_SAMPLERATE => 44100);

# try to connect
if ($conn->open) {
    warn qq(Connected to server '$server:$server_port' at )
        . qq(mountpoint '$mountpoint' as user '$user'\n);
    # read in the playlist from STDIN
    my @playlist = <STDIN>;
    # make a copy of the playlist before we start munging it
    my @song_q = @playlist;

    warn qq(Use the command 'touch /tmp/streambake.die' )
        . qq(to cause the server to exit\n);
    while ( ! -e q(/tmp/streambake.die) ) {
        my $current_song;
        my $song_q_length = scalar(@song_q);
        warn qq(There are currently $song_q_length songs in the song Q\n);
        my $random_song = int(rand($song_q_length));
        $current_song = splice(@song_q, $random_song, 1);
        chomp($current_song);
        warn qq(Current song is $current_song\n);
        if ( ! -e $current_song ) { 
            warn qq(File '$current_song' doesn't exist\n); 
            next;
        } # if ( ! -e $current_song ) 
        # just get the name of the file for metadata
        my @song_metadata = split(q(/), $current_song);
        # generate the metadata items using the song's filename
        my $track_name = $song_metadata[-1];
        $track_name =~ s/\.mp3$//;
        # remove leading numbers with dashes from the track name
        if ( $track_name =~ /^\d+-/ ) { $track_name =~ s/^\d+-//; }
        # remove leading numbers with spaces from the trackname
        if ( $track_name =~ /^\d+ / ) { $track_name =~ s/^\d+ //; }
        my $album_name = $song_metadata[-2];
        my $artist_name = $song_metadata[-3];
        # if we connect, grab data from stdin and shoot it to the server
        my ($buff, $len);

        warn q(Opening file for streaming at ) 
            . sprintf(q(%02u), $dt->day) . $dt->month_abbr . $dt->year 
            . q( ) . $dt->hms . qq(\n);
        warn qq('$current_song'\n); 
        $conn->set_metadata( 
            "song" => "$artist_name - $album_name - $track_name" );
        #undef $tf;
        open(MP3FILE, "< $current_song") 
            || die qq(Can't open $current_song : '$!');
        my $bytes_read;
        while (($len = sysread(MP3FILE, $buff, 4096)) > 0) {
    	    unless ( $conn->send($buff, 4096) ) {
	            warn "Error while sending: " . $conn->get_error . "\n";
                # 
    	        $conn->sync;
            	last;
            } # unless ($conn->send($buff)) 
            # must be careful not to send the data too fast :)
    	    $conn->sync;
        } # while (($len = sysread(MP3FILE, $buff, 4096)) > 0)
        close(MP3FILE);
        warn qq(Closing file;\n$current_song\n);

        if ( scalar(@song_q) == 0 ) {
            print qq(Reloading song queue;\n);
            @song_q = @playlist;
        } # if ( scalar(@song_q) == 0 )  
    } # while ( -e q(/tmp/streambake.die) 

    # all done
    $conn->close;
} else {
    warn qq(couldn't connect to server; ) . $conn->get_error . qq(\n);
} # if ($conn->open)

=head1 AUTHOR

Brian Manning, C<< <elspicyjack at gmail dot com> >>

=head1 BUGS

Please report any bugs or feature requests to 
C<< <streambake at googlegroups dot com> >>.

=head1 SUPPORT

You can find documentation for this script with the perldoc command.

    perldoc simplebake.pl

=head1 COPYRIGHT & LICENSE

Copyright (c) 2008,2010 Brian Manning, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

# fin!
# vim: set sw=4 ts=4
