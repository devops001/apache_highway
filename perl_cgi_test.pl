#!/usr/bin/perl

sub escape {
  my $line = $_[0];
  $line =~ s/</&lt;/g;
  $line =~ s/>/&gt;/g;
  return $line;
}

my @html;

push(@html, "Content-type: text/html\n\n");
push(@html, "<!doctype html><html><head><meta charset='utf-8'></head><body><h1>perl works</h1>\n");

###############################################
## display ENV varaibles:
###############################################

push(@html, "<hr/><h3>ENV variables available:</h3><pre>\n");
foreach $key (keys %ENV) {
  my $val = $ENV{$key};
  push(@html, "$key = ". escape($val) ."\n");
}
push(@html, "</pre>\n");

###############################################
## display this script:
###############################################

push(@html, "<hr/><h3>This script:</h3><pre>\n");
open(SCRIPT, "<$0");
foreach my $line (<SCRIPT>) {
  push(@html, escape($line));
}
close(SCRIPT);
push(@html, "</pre>\n");

###############################################
## print html:
###############################################

push(@html, "</body></html>\n");
print join("", @html);

