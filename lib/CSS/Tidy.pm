package CSS::Tidy;
use warnings;
use strict;
use Carp;
use utf8;
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw/tidy_css/;
our %EXPORT_TAGS = (
    all => \@EXPORT_OK,
);
our $VERSION = '0.00_01';

sub tidy_css
{
    my ($text) = @_;

    my $depth = 0;
    my $comment = 0;

    my @lines = split /\n/, $text;

    my @tidy;

    for (@lines) {
	if (m!^\s*/\*!) {
	    if (! m!/\*.*?\*/!) {
		$comment = 1;
		push @tidy, $_;
		next;
	    }
	}
	if ($comment) {
	    if (m!.*?\*/!) {
		$comment = 0;
		push @tidy, $_;
		next;
	    }
	}
	if (/\}/) {
	    $depth--;
	}
	my $initial = '';
	if (/^(\s*)/) {
	    $initial = $1;
	}
	if (length ($initial) != $depth * 4) {
	    s/^$initial/'    ' x $depth/e;
	}
	# If not a CSS pseudoclass
	if (! /(?:\.|#)\w+:/) {
	    # Insert a space after a colon
	    s/:(\S)/: $1/;
	}
	s/\s+$//;
	push @tidy, $_;
	if (/\{/) {
	    $depth++;
	}
    }

    my $out = join ("\n", @tidy);
    # Reduce multiple blank lines to a single one.
    $out =~ s/\n+/\n/g;
    # Add a blank after }
    $out =~ s/^(\s*\})/$1\n/gsm;
    # Remove a blank line before }. This also tidies up the
    # aftereffects of the above regex, which puts too many blank
    # lines.
    $out =~ s/\n\n(\s*\})/\n$1/g;
    # Add a blank line after comments.
    $out =~ s!(\*/)!$1\n!g;
    return $out;
}

1;
