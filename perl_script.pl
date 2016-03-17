#!/usr/bin/perl
use strict;
use warnings;

print "Usage: perl script.pl fasta_one_line threshold(even number ONLY)\n\n";

my $fasta = $ARGV[0];
$fasta =~ s/\r?\n//g;
my $threshold = $ARGV[1];
$threshold =~ s/\r?\n//g;

if ($threshold % 2 == 0){
print "Okay, $threshold is an even number.\n\n";
}
else
{
die "I need an even number...\nTry again ...\n";
}

my $output;
if ($fasta =~ /\//) {$output = (split(/\//,$fasta))[-1] . "gc_content"} else{$output = $fasta . "gc_content"}
open (OUT, ">", $output) or die "can't open $!";
open (OUT2, ">", $output . ".log") or die "can't open $!";

open (IN, "<", $fasta) or die "can't open  $!";

my %h_pcent;
my $size_fasta;

my $sequence;
my $not_sequence = 0;

while (my $line = <IN>) {
$line =~ s/\r?\n//g;
$line =~ s/\s//g;
if ($line !~ m/^>/)
{
$sequence .= $line;
}
else
{
$not_sequence++;
}
}

if ($not_sequence > 1) {print "Your fasta file contains more than one sequence (i found the > symbol $not_sequence times, i'll die now ...\n"; die}

$size_fasta = length($sequence);

if ($sequence =~ m/[^ATGC]/)
{
print "Your fasta sequence contains other caracters than [ATGC], i'll keep working normally, it's just so you know ...\n ";
}

print "Well, now i'm doing this, i'll display the mean GC content of the sequence as well even if you didn't ask ...\nYour sequence has ...\n";
my $count1 = 0;
while ($sequence =~ /[GC]/g) { $count1++ }
my $pcent =  $count1 / $size_fasta * 100 ;
print "$pcent % mean GC content \n";
my $line_mod = (substr $sequence, -$threshold/2 ) . $sequence . (substr $sequence, 0, ($threshold / 2));
print OUT2 $line_mod . "\n";



my $start = 0;

until ($start > (length($sequence)))
{
my $count = 0;
my $tmp = substr $line_mod, $start, $threshold;

my $position = $start;

while ($tmp =~ /[GC]/g) 
{ $count++}

print OUT2 $count . " " . $tmp . "\n";
my $pcent =  $count / $threshold ;

$h_pcent{$position} = $pcent;
$start ++;  #    $start += $threshold; if i choose to calculate the mean on the windw instead of making it for each nucleotid 
}



my $k = 0;
my $acc = 0;

foreach my $key ( sort {$a<=>$b} keys %h_pcent)
{
$k++;
$acc += $h_pcent{$key};
print OUT2 "$acc\n";
	if ($k == $threshold || $key == $size_fasta) 
	{
	my $res = ($acc/$k);
	my $start_window = $key + 1 - $k;
	my $end_window = $key +1; if($end_window > $size_fasta){$end_window = $size_fasta}
	print OUT "chr1 " . $start_window . " " . $end_window . " " . $res . "\n";

	$acc = 0;
	$k = 0;
	}
}


close IN;
close OUT;
close OUT2;


