#!/usr/bin/perl
use warnings;
use strict;

my $old_release = $ARGV[0];
my $new_release = $ARGV[1];
my $release_date = $ARGV[2];
my $release_manager = $ARGV[3];

my($major_version) = $new_release =~ /^([0-9]+\.[0-9]+)/;

print "Migrating news for $old_release to oldnews.xml, major version $major_version, RM $release_manager\n";

open(OLD_NEWS, '<', 'xdocs/oldnews.xml') or die 'Cannot open xdocs/oldnews.xml for reading';
open(OLD_NEWS_NEW, '>', 'xdocs/oldnews.xml.new') or die 'Cannot open xdocs/oldnews.xml.new for writing';

my $found_new_announcement_location=0;
my $line = 0;
my $old_announcement_start_line = 0;
my $old_announcement_end_line = 0;

# Locate the place in the old news where we will insert the old announcement.
while(<OLD_NEWS>) {
  if( /<\/section>/ ) {
    print "Found location in oldnews.xml to place old release announcement.\n";
    print OLD_NEWS_NEW;

    $found_new_announcement_location = 1;
    last; # Abort this loop; start the next one
  } else {
    print OLD_NEWS_NEW;
  }
}

die 'Failed to find old announcement target location in xdocs/oldnews.xml' unless 1 == $found_new_announcement_location;

open(NEWS, '<', 'xdocs/index.xml') or die 'Cannot open xdocs/index.xml for reading';
open(NEWS_NEW, '>', 'xdocs/index.xml.new') or die 'Cannot open xdocs/index.xml.new for writing';

my $migrating = 0;
my $finish = 0;
my $added_template = 0;

print "Looking for old release announcement for $old_release ...\n";

while(<NEWS>) {
  ++$line;
  if($finish == 1) {
    print NEWS_NEW;
  } elsif($migrating == 1) {
    print OLD_NEWS_NEW;

    if( /<\/section>/ ) {
      print "Found old release announcement ending on line $line.\n";
      print "Finished copying old announcement to old news.\n";
      $finish = 1;
    }
  } elsif ( /<section.*Tomcat $old_release Released/ ) {
    print "Found old release announcement starting on line $line.\n";

    print OLD_NEWS_NEW;

    $migrating = 1;
  } elsif ( $added_template == 0 and /<\/section>/ ) {
    print NEWS_NEW;
    print "Found the beginning of the news. Adding new release announcement template.\n";

    open(ANNOUNCEMENT_TEMPLATE, '<', "tools/news-template-${major_version}.xml") or die "Cannot open tools/news-template-${major_version}.txt for reading.\n";

    while(<ANNOUNCEMENT_TEMPLATE>) {
      s/\{NEW_RELEASE\}/$new_release/g;
      s/\{RELEASE_DATE\}/$release_date/g;
      s/\{RELEASE_MANAGER\}/$release_manager/g;
      print NEWS_NEW;
    }
    close(ANNOUNCEMENT_TEMPLATE);

    $added_template = 1;
  } else {
    print NEWS_NEW;
  }
}

close(NEWS_NEW);
close(NEWS);

die 'Failed to add new release announcement template.' unless $added_template == 1;
die 'Failed to complete copying old release announcement.' unless $finish == 1;

print "Copying the rest of the old news.\n";

while(<OLD_NEWS>) {
  print OLD_NEWS_NEW;
}
close(OLD_NEWS_NEW);
close(OLD_NEWS);

print "Looks like everything went well. Swapping files.\n";

unlink('xdocs/index.xml') or die 'Failed to delete xdocs/index.xml';
unlink('xdocs/oldnews.xml') or die 'Failed to delete xdocs/oldnews.xml';
rename('xdocs/index.xml.new', 'xdocs/index.xml') or die 'Failed to rename xdocs/index.xml.new -> xdocs/index.xml';
rename('xdocs/oldnews.xml.new', 'xdocs/oldnews.xml') or die 'Failed to rename xdocs/oldnews.xml.new -> xdocs/oldnews.xml';

