#!/usr/bin/perl -w

use strict;
use warnings;

use constant STATUS_OK => 0;
use constant STATUS_WARN => 1;
use constant STATUS_CRITICAL => 2;
use constant STATUS_UNKNOWN => 3;

my $snmpget = '/usr/bin/snmpget';

my $warn;
my $crit;
my $swap;

use Getopt::Long;

sub usage {
        print "Usage: $0 -w NUM -c NUM [-s] -- [snmpget options]\n";
        print "\t-w\twarning threshhold\n";
        print "\t-c\tcritical threshhold\n";
        print "\t-s\tcheck swap instead of memory\n";
        print "EXAMPLES:\n";
        print "\tsnmp v1:\n";
        print "\t$0 -w 85 -c 95 -- -c community example.com\n";
        print "\tsnmp v3:\n";
        print "\t$0 -w 85 -c 95 -- -v3 -l authPriv -a MD5 -u exampleuser -A \"example password\" example.com\n";
        exit STATUS_UNKNOWN;
}

map { $_ = '"' . $_ . '"' if $_ =~ / /} @ARGV;
map { $_ = "'" . $_ . "'" if $_ =~ /"/} @ARGV;

my $STR = join(" ", @ARGV);

sub do_snmp {
        my ($OID) = @_; 

        my $cmd = $snmpget . " " . $STR . " " . $OID;
            
chomp(my $out = `$cmd 2> /dev/null`);

        if ($? != 0) {
                print "SNMP problem - no value returned\n";
                print "$?\n";
                exit STATUS_UNKNOWN;
        }

        my $type;

        my ($jnk, $x) = split / = /, $out, 2;

        if ($x =~ /([a-zA-Z0-9]+): ([0-9]+)[ ]?(kB)?$/) {
                $type = $1; 
                $x = $2; 
        }

        return $x; 
}

my $fanPwm = ''; # Add OID
my $fanRpm = ''; # Add OID

my $pwm = do_snmp($fanPwm);
my $rpm = do_snmp($fanRpm);

my $ret;

$pwm =~ s/"//g;
$pwm =~ s/\s//g;

my $power = unpack "f", pack "H*",  $pwm;

if ($power >= 90 && $rpm == 0){ 
    print "Fan is unavailable or is missing";
    $ret = STATUS_CRITICAL;
} elsif ($power == 0 && $rpm == 0) {
    print "Fan is not running, but it is ok";
    $ret = STATUS_OK;
} else {
    print "$rpm rpm at $power %";
    $ret = STATUS_OK;
}

print " | rpm=$rpm; pwm=$power\n"; 

exit $ret

