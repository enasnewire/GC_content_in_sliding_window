#!/usr/bin/perl
use strict;
use warnings;

print "Only works for ONE LINE FASTA FILE !!! \n\n";
print "Usage: perl script.pl fasta_one_line threshold(even number ONLY)\n\n";

my $fasta = $ARGV[0];
$fasta =~ s/\r?\n//g;
my $threshold = $ARGV[1];
$threshold =~ s/\r?\n//g;

if ($threshold % 2 == 0){
print "Okay, $threshold is an even number.\n";
}
else
{
die "I need an even number\nTry again ...\n";
}

my $output;
if ($fasta =~ /\//) {$output = (split(/\//,$fasta))[-1] . "gc_content"} else{$output = $fasta . "gc_content"}
open (OUT, ">>", $output) or die "can't open $!";
open (OUT2, ">>", $output . ".log") or die "can't open $!";
open (IN, "<", $fasta) or die "can't open  $!";

my %h_pcent;

my $remember_size_fasta;

while (my $line = <IN>) {
$line =~ s/\r?\n//g;

my $line_mod = (substr $line, ((length($line)) - ($threshold / 2)), ($threshold / 2)) . $line . (substr $line, 0, ($threshold / 2));

if ($line !~ m/^>/)
{
$remember_size_fasta = length($line);
my $start = 0;

until ($start >= (length($line)))
{
my $count = 0;
my $tmp = substr $line_mod, $start, $threshold;

my $position = $start;

while ($tmp =~ /[GC]/g) { $count++ }
print OUT2 $count . " " . $tmp . "\n";
#my $pcent = 100 * $count / $threshold ;
my $pcent =  $count / $threshold ;

$h_pcent{$position} = $pcent;
$start ++;
}


#premiers nucléotides de la séquence
#my $debut = ;


#derniers nucléotides de la séquence


}
}

my $k = 0;
my $acc = 0;

my $remember_last_key;
my $remember_last_res;

foreach my $key ( sort {$a<=>$b} keys %h_pcent)
{
$k++;
#print OUT2 "$key\n";
if ($k == $threshold)
{
$acc += $h_pcent{$key};
my $res = ($acc/$threshold);
$acc = 0;
my $key_minus_10 = $key - ($threshold-1);
my $key_and_1 = $key +1;
print OUT "chr1 " . $key_minus_10 . " " . $key_and_1 . " " . $res . "\n";
$remember_last_key = $key_and_1;
$remember_last_res = $res;
$k = 0;
}
else
{
$acc += $h_pcent{$key};
}



#my $key_and_1 = $key +1;

#chr1 1000 1500 0.237788
print OUT2 "chr1 " . $key . " " . $key . " " . $h_pcent{$key} . "\n";

}

print OUT "chr1 " . $remember_last_key . " " . $remember_size_fasta . " " . $remember_last_res . "\n"; 



close IN;
close OUT;
close OUT2;
