#!/usr/bin/perl
use strict;
use warnings;

# This script modifies a migration file to update the drop-downs.
#
# In the "from" drop-down:
# - remove 'selected' attribute from any old release
# - add 'selected' attribute to old release
# - add the new release
#
# In the "to" drop-down:
# - remove 'selected' from the old release
# - add the new release, including 'selected' attribute
sub usage {
  print "Usage: $0 old-release new-release\n";
}

if(scalar @ARGV < 2) {
  usage;

  exit 1;
}

my($old_release) = shift;
my($new_release) = shift;
my($minor_release) = ( $new_release =~ /^([0-9]*\.[0-9]*)/ );

# print "new=$new_release minor=$minor_release\n";

my($skip_lines) = 0;

my($found_old_old_release_selected) = 0;
my($found_old_release_unselected) = 0;
my($found_old_release_selected) = 0;

#
# There are 3 stages to this script:
# 1. Looking for "from" drop-down old-old release, to remove the "selected" attribute.
# 2. Looking for "from" drop-down old release, to add the "selected" attribute,
#    then add the new release with no selected attribute.
# 3. Looking for the "to" drop-down old release, to remove the "selected" attribute,
#    then add the new release with selected="true"
# 
# print "1. Looking for <option value=\"${minor_release}.*\" selected\n";
while(<>) {
  if ( $skip_lines > 0 ) {
    --$skip_lines;
    next;
  }

  if (!$found_old_old_release_selected) {
    if ( /<option value="${minor_release}.*" selected/ and ! /<option value="${old_release}" selected/ ) {
      $found_old_old_release_selected = 1;

      s/ selected(="selected")?//; # Remove the "selected" attribute

      print; # Dump the altered line

#print "2. Now looking for <option value=\"$old_release\">\n";
    } else {
      print;
    }
  } elsif(!$found_old_release_unselected) {
    if ( /<option value="$old_release">/ ) {
      $found_old_release_unselected = 1;

      s/">/" selected>/;

      print; # Dump the altered line

      # Add the new release, unselected
      print "    <option value=\"$new_release\">$new_release</option>\n";
# print "3. Now looking for <option value=\"$old_release\" selected=\"selected\">\n";
    } else {
      print;
    }
  } elsif(!$found_old_release_selected) {
    if ( /<option value="$old_release" selected/ ) {
      $found_old_release_selected = 1;

      s/ selected(="selected")?//; # Remove the "selected" attribute

      print; # Dump the altered line

      # Add the new release at the end
      print "    <option value=\"$new_release\" selected>$new_release</option>\n";
    } else {
      print;
    }
  } else {
    print; # Finish-off the file
  }
}
if(!$found_old_old_release_selected or !$found_old_release_unselected or !$found_old_release_selected) {
  #print STDERR "Something went wrong patching migration.\n";

  exit(1);
}

