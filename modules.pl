#!/home/ben/software/install/bin/perl
use Z;

use MetaCPAN::Client;
use JSON::Create 'create_json';
use Perl::Build::Pod ':all';

# Read the file in & extract the section

my $text = see_also ("$Bin/lib/CSS/Tidy.pod.tmpl");

my $mcpan = MetaCPAN::Client->new ();

my @modules;

eval {
    while ($text =~ /$mod_re/g) {
	my $module = $1;
	print "$module\n";
#	next;
	my $mod = $mcpan->module ($module);
	my $dist = $mod->distribution ();
	my $fav = $mcpan->favorite ({distribution => $dist});
	my %info;
	$info{module} = $module;
	$info{version} = $mod->version ();
	$info{author} = $mod->author ();
	$info{date} = $mod->date ();
	$info{fav} = $fav->total ();
	push @modules, \%info;
    }
};
if ($@) {
    print "error: $@";
}
my $mtext = create_json (\@modules, sort => 1, indent => 1);
write_text ("see-also-info.json", $mtext);


