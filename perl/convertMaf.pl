#!/usr/bin/perl -w
# Last Time-stamp: <2014-07-13 12:51:01 at>
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

my $help    = 0;
my $man     = 0;
my $seqID;
my $version;
my $cluster;
my $off = 1;
my $out_format = "CLUSTAL";

GetOptions('seq-id|s=s'   => \$seqID,
	   'cluster|c'    => \$cluster,
           'offset|off:i' => \$off,
	   'outformat|f:s'=> \$out_format,
	   'version|v'    => \$version,
	   'help|h'       => \$help,
	   'man'          => \$man
    ) or pod2usage(1);

# Known output formats
my %out_formats = ("CLUSTAL" => undef,
		   "MAF"     => undef);

# Error message: no output format or not exsisting format specified
die("Please specify a valid output format:\n", join(", ", (sort keys %out_formats)),"\n") unless (defined(uc($out_format)) || exists($out_formats{uc($out_format)}));

# set the format
#$out_formats{$out} = 1;

pod2usage(1) if $help;
pod2usage(-verbose => 2) if $man;

if ($version){
  print "\convertMAF.pl is part of RNAz $RNAz::rnazVersion\n\n";
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
#print "format: $alnFormat\n";

while ( my $alnString = getNextAln( $alnFormat, $fh ) ) {

  # name, start, length, strand, fullLength, seq, org, chrom
  my ($fullAln, $orgs) = parseAln( $alnString, $alnFormat, "1" );

  # only reference species in alignment
  next if scalar(@$fullAln) < 2;

  $alnCounter++;

# Print alignment in clustal format  
  print(formatAln($fullAln,uc($out_format))), last if $alnCounter == $off;  

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

