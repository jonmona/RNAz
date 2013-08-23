#!/usr/bin/perl -w
# Last Time-stamp: <2013-08-23 19:44:43 at>
# date-o-birth: <2013-08-22 12:11:45 at>, vienna
# parent: rnazMAF2BED.pl
# converts maf locks into coordinate files
# default: bed6, for reference sequence/organism only (=first in fist alignment block)

# $Id: rnazMAF2BED.pl,v 1.3 2008-01-24 10:26:45 wash Exp $


#TODO: handle UCSC style a la: hg17.chr17

use strict;
use FindBin;
use lib $FindBin::Bin;
use RNAz;
use Getopt::Long;
use Pod::Usage;
use AnnotUtil qw(printGtfFieldsAndAttributes);

my $help;
my $seqID;
my $version;
my $cluster;
my $man;
my $out;

GetOptions('seq-id|s=s'   => \$seqID,
	   'cluster|c'    => \$cluster,
	   'out|format:s' => \$out,
	   'version|v'    => \$version,
	   'help|h'       => \$help,
	   'man'          => \$man
    ) or pod2usage(1);

my %out_formats = ("gtf" => '',
		   "bed" => '');

# Error message: no output format or not exsisting format specified
die("Please specify a valid output format:\n", join(", ", (sort keys %out_formats)),"\n") unless (defined($out) || exists($out_formats{$out}));

# set the format
$out_formats{$out} = 1;

pod2usage(1) if $help;
pod2usage(-verbose => 2) if $man;

if ($version){
  print "\nrnazMAF2BED.pl is part of RNAz $RNAz::rnazVersion\n\n";
  print "http://www.tbi.univie.ac.at/~wash/RNAz\n\n";
  exit(0);
}

my $fileName = shift @ARGV;
my $fh;

if ( !defined $fileName ) {
  $fh = *STDIN;
} else {
  open( $fh, "<$fileName" ) || die("Could not open file $fileName ($!)");
}

# Some Variables
my $alnCounter = 0;

my $alnFormat = checkFormat($fh); # works only with MAF for now!

while ( my $alnString = getNextAln( $alnFormat, $fh ) ) {

  # name, start, length, strand, fullLength, seq, org, chrom
  my ($fullAln, $orgs) = parseAln( $alnString, $alnFormat, "1" );

  # only reference species in alignment
  next if scalar(@$fullAln) < 2;

  $alnCounter++;
  
  # Block length of current alignment
  my $l = length($fullAln->[0]->{seq});
  
  # mean pairwise ID
  my $meanPairID = meanPairID($fullAln) * 100;

  # prepare data for printing
  my %add = ("meanPairID"   => [$meanPairID],
	     "blockNr"      => [$alnCounter],
	     "block_length" => [$l],
	     "org_block"    => [sort keys %$orgs],
	     "nr_org"       => [scalar(keys %$orgs)]);
  
  my ($blocks) = &mafToGtf($fullAln,\%add) if $out_formats{"gtf"};

  for my $i (0.. $#$blocks){
    my ($fields, $attribs) = @{$blocks->[$i]};
    printGtfFieldsAndAttributes($fields, $attribs,*STDOUT);
  }
}


sub mafToGtf{
  my ($fullAln,$add) = @_;

  # reformat attribs: add double quotes
  foreach my $k (keys %$add){
    $_ = "\"".$_."\"" foreach @{$add->{$k}};
  }

  my @block = ();
  my $id    = "";
  
  for my $i (0..$#$fullAln){

    # if sequence on minus strand, the start is relative to end of chromosome
    my $start = $fullAln->[$i]->{start} + 1;
    my $end   = $fullAln->[$i]->{start} + $fullAln->[$i]->{length};
    
    if ($fullAln->[$i]->{strand} eq "-"){
      $start = $fullAln->[$i]->{fullLength} - $fullAln->[$i]->{start} - $fullAln->[$i]->{length} + 1;
      $end   = $fullAln->[$i]->{fullLength} - $fullAln->[$i]->{start};
    }
    
    my %fields = ("chr"        => $fullAln->[$i]->{chrom},
		  "source"     => "maf",
		  "type"       => "exon",
		  "start"      => $start,
		  "end"        => $end,
		  "score"      => ".",
		  "strand"     => $fullAln->[$i]->{strand},
		  "phase"      => ".",
		  "attributes" => "");
    

    # ID of reference sequence
    # do this once for first line in block ($i==0)
    $id = join("_",$fields{chr},$start,$end) if ($i == 0);

    my %attribs = %$add;
    $attribs{org}->[0]           = "\"".$fullAln->[$i]->{org}."\"";
    $attribs{gene_id}->[0]       = "\"".$id."\"";
    $attribs{transcript_id}->[0] = "\"".$id."\"";
    
    push(@block,[\%fields, \%attribs]);
  }
  return(\@block);
}


__END__

=head1 NAME

C<rnazMAF2BED.pl> - Convert sequence information from MAF formatted
multiple sequence alignment to a BED style annotation format.

=head1 SYNOPSIS

 rnazMAF2BED.pl [options] [file]

=head1 OPTIONS

=over 8

=item B<-s, --seq-id>

Specify the sequence identifier of the sequence which should be used
as a reference to create the output. Use for example C<hg17> if you
want to get all sequences containing C<hg17> in the idenitfier
(e.g. C<hg17.chr10>, C<hg17.chr22>,...). If this option is omitted,
the first sequence identifier of the first sequence in the first
alignment block is used.

=item B<-c, --cluster>

Combine overlapping alignments and report non-overlapping
regions in the BED output. 

=item B<-v, --version>

Prints version information and exits.

=item B<-h, --help>

Prints a short help message and exits.

=item B<--man>

Prints a detailed manual page and exits.

=back

=head1 DESCRIPTION

This simple programs extracts the position information for a given
sequence out of a MAF alignment and outputs it in a BED style
annotation format.

=head1 EXAMPLES

 # rnazMAF2BED.pl -s hg17 some.maf

Get the regions of the hg17 sequences in the alignment C<some.maf>.

=head1 AUTHORS

Stefan Washietl <wash@tbi.univie.ac.at>

=cut

