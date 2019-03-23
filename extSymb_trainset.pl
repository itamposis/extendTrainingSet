#! /usr/bin/perl -w
use Algorithm::Combinatorics qw(:all);
use Getopt::Long;
use strict; 
use warnings;

####################################################
# AUTHOR      : Ioannis Tamposis
# CONTACT     : Pantelis Bagos, pbagos@compgen.org
# DATE        : 12/03/2017
# FILENAME    :
# VERSION     : 2.1
# DESCRIPTION :
#
# USAGE : -i <input training file> -o <output training file> -e <encoding> -t <past Observations>
#         -i trainSet.seq -o trainSetExt.seq -e 2 -t 1
####################################################

use utf8;
#use mode for utf8
binmode(STDOUT, ":utf8");

####################################################
# Global Parameters
#Encoding 1 All (400)
#Encoding 2 Hydrophobic (40)
#Encoding 3 Hydrophobic-Aromatic-Positive-Polar (80)
#Encoding 4 (160)
my $encoding = 2;
####################################################

#the total number of Previous symbols (t)
my $t = 0;

#start utf8 position number
my $lexStartPosition = 913;

# Encoding Groups
my $esym = "ACDEFGHIKLMNPQRSTVWY";
my $enc1 = "10001011011000000111";
my $enc2 = "24331212322444344211";
my $enc3 = "12558187677424633788";

my $esymNew = "";
my $lex;
my $hsym;
my $inFile = "&STDIN";
my $outFile = "&STDOUT";

####################################################
#Parse the Command Line
####################################################
Getopt::Long::Configure ('bundling');
GetOptions(
    'i|input_file=s' => \$inFile,
    'o|out_file=s' => \$outFile,
    'e|encode=i' => \$encoding,
    't|pastObs=i' => \$t
    );

if(scalar(@ARGV) == 1 || !defined($inFile) || !defined($outFile)){
    die ("USAGE: $0 -i <input training file> -o <output training file> -e <encoding> -t <past Observations>");
}

open(INFILE, "<$inFile") or die ("Couldnt open input file $inFile \n ");	
open(OUTFILE,">:utf8","$outFile") or die ("Couldnt open output file $outFile \n ");s

my $lex1 = [qw(1 0)];
my $lex2 = [qw(1 2 3 4)];
my $lex3 = [qw(1 2 3 4 5 6 7 8)];
my $lex4 = [qw(A C D E F G H I K L M N P Q R S T V W Y)];

  
# Lexicon
if   ($encoding == 1) { $lex = $lex4; $hsym = $esym;}
elsif($encoding == 2) { $lex = $lex1; $hsym = $enc1;}
elsif($encoding == 3) { $lex = $lex2; $hsym = $enc2;}
elsif($encoding == 4) { $lex = $lex3; $hsym = $enc3;}

#Hash Array with Lexicon
my %lexMatrix;

#Create Lexicon
makeLexicon();
#print "esymNew : $esymNew\n";

#Read line by line
my @lines = <INFILE>;
for (my $i = 0; $i <= $#lines; $i++) {
    if ($lines[$i]=~ m/^>/)
    {
        my $id    = $lines[$i];
        my $seq   = $lines[$i+1];
        my $states= $lines[$i+2];
        $seq = join('',split(/\n/,$seq));
        print OUTFILE "$id".getSeqWithNewLex($seq)."\n$states"
    }
}
close(INFILE)  or die ("Couldnt close input file $inFile \n ");
close(OUTFILE)  or die ("Couldnt close output file $outFile \n ");
exit;

####################################################
# Methods
####################################################
sub getSeqWithNewLex{
    my $s = $_[0];
    
    my $sNew = "";
    my $prev;
    #first character and as previous used letter A:Alanine
    for my $i (1 .. $t) {
        $s = 'A'.$s;
    }
    
    for my $i ($t..length($s)-1){
        my $key = "";
        for my $j (1 .. $t) {
            $prev = substr($hsym,  index ($esym, substr($s,$i-$j,1)), 1);
            $key = join("",$key,$prev);
        }

        $key = join("",$key,substr($s,$i,1));
        $sNew =  join("",$sNew,getLexiconChar($key));
    }
    return $sNew;
   
}

sub getLexiconChar{
    if (exists $lexMatrix{$_[0]}){
        return $lexMatrix{$_[0]};
    }
}

sub makeLexicon{
    my $i = $lexStartPosition;
    my $key;
    
    foreach my $char1 (split //, $esym)
    {
        my $iter = variations_with_repetition($lex, $t);
        while (my $c = $iter->next) {
            $key = join('', @$c,$char1);
            $lexMatrix{$key} = chr($i);  
            $esymNew = join("",$esymNew,chr($i));
            $i++;
        }
    }
}

