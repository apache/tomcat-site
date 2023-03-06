#!/usr/bin/perl
use strict;
use warnings;

# This script modifies the Tomcat DOAP file to update to the latest release.
#
#    <release>
#      <Version>
#        <name>Latest Stable 10.0.x Release</name> <-- Look for this line
#        <created>2022-10-10</created> <-- Add this line, ignore original
#        <revision>10.0.27</revision>  <-- Add this line, ignore original
#      </Version>
#    </release>
sub usage {
  print "Usage: $0 release date\n";
}

if(scalar @ARGV < 2) {
  usage;

  exit 1;
}

my($new_release) = shift;
my($release_date) = shift;
my($minor_release) = ( $new_release =~ /^([0-9]*\.[0-9]*)/ );

# print "new=$new_release minor=$minor_release\n";

my($skip_lines) = 0;

while(<>) {
  if ( $skip_lines > 0 ) {
    --$skip_lines;
    next;
  }

  if ( /Latest Stable ${minor_release}/ ) {
    print; # Dump the header

    print "        <created>${release_date}</created>\n";
    print "        <revision>${new_release}</revision>\n";
    
    $skip_lines = 2;
  } else {
    print;
  }
}
