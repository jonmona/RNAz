#!/usr/bin/perl -w

# -*-Perl-*-
# Last changed Time-stamp: <2009-02-23 18:28:47 ivo>

use strict;
use FindBin;
use lib $FindBin::Bin;
use RNAz;
use Getopt::Long;
use Pod::Usage;

my $count=0;
my $help=0;
my $man=0;
my $version=0;

GetOptions('count'=>\$count,
		   'version'=>\$version,
		   'v'=>\$version,
		   'help'=>\$help,
		   'man'=>\$man,
		   'h'=>\$help ) or pod2usage(1);

pod2usage(1) if $help;
pod2usage(-verbose => 2) if $man;

if ($version){
  print "\nrnazFilter.pl is part of RNAz $RNAz::rnazVersion\n\n";
  print "http://www.tbi.univie.ac.at/~wash/RNAz\n\n";
  exit(0);
}

# named column indices
my %columnNames = (hitID          => 1,
		   clusterID      => 2,
		   seqID          => 3,
		   start          => 4,
		   end            => 5,
		   strand         => 6,
		   N              => 7,
		   columns        => 8,
		   identity       => 9,
		   meanMFE        => 10,
		   consensusMFE   => 11,
		   energyTerm     => 12,
		   covarianceTerm => 13,
		   combPerPair    => 14,
		   z              => 15,
		   SCI            => 16,
		   decValue       => 17,
		   P              => 18);

my %fields;

my $filter=shift @ARGV;

foreach my $field (keys %columnNames){
  $filter=~s/$field/COL$columnNames{$field}/g;
}
$filter =~ s/(COL\d+)/\$fields{$1}/g;

# memorize column numbers
my @columnIDs = ($filter=~ m/COL(\d+)/g);

my $nCluster=0;
my $nWindow=0;

my $currClusterLine='';

foreach my $line (<>){

  next if $line=~/^\s?\#/;
  next if $line=~/^\s+$/;

  if ($line=~/^\s?locus\d+/){
	$currClusterLine=$line;
	next;
  }

  my @F = split(/\s+/,$line);
  foreach my $id (@columnIDs) {
      $fields{'COL'.$id} = $F[$id-1];
  }

  local $SIG{__WARN__} =
	sub {
	  print STDERR ("You have an error in your filter statement.\n");
	  exit(1);
	};
  local $SIG{__DIE__}=$SIG{__WARN__};

  my $flag=eval $filter;

  if ($flag){
	if ($currClusterLine){
	  print $currClusterLine if (!$count);
	  $currClusterLine='';
	  $nCluster++;
	}
	print $line if (!$count);
	$nWindow++;
  }
}

if ($count){
  print "Loci: $nCluster\n";
  print "Windows: $nWindow\n";
}

__END__

=head1 NAME

C<rnazFilter.pl> - Filter output files from C<rnazCluster.pl> by different criteria.

=head1 SYNOPSIS

 rnazFilter.pl [options] "filter" [file]

=head1 OPTIONS

=over 8


=item B<-c, --count>

Count the windows/loci instead of printing them.

=item B<-v, --version>

Prints version information and exits.

=item B<-h, --help>

Print a short help message and exits.

=item B<--man>

Prints a detailed manual page and exits.

=back

=head1 DESCRIPTION

C<rnazFilter.pl> reads tab-delimited data files as generated by
C<rnazCluster.pl>. For each window a filter is applied and if the
filter is passed the window and the corresponding locus are printed
out. Thus, you get all loci with at least one window that fulfills your
filter criteria.

The mandatory filter statement is given within double quotes (" ") and
can contain comparison/logical statements and field identifiers as
listed below.

Technically, the statement is directly interpreted by Perl, so you can
use anything which works in Perl. The same caveats apply, for example:
If you want compare numbers you must use C<==>, if you compare strings
you have to use C<eq>.

Please note: I<everything> you put in the filter statement is
evaluated by Perl. This can be potentially harmful, so take care.

=head1 FIELDS

=over 8

=item 1. B<windowID>

Consecutive numbered ID for each window

=item 2. B<locusID>

The locus which this window belongs to

=item 3. B<seqID>

Identifier of the sequence (e.g. human.chr1 or contig42)

=item 4. B<start>

Start position of the reference sequence in the window

=item 5. B<end>

End position of the reference sequence in the window

=item 6. B<strand>

Indicates if the reference sequence is from the positive or
negative strand

=item 7. B<N>

Number of sequences in the alignment

=item 8. B<columns>

Number of columns in the alignment

=item 9. B<identity>

Mean pairwise identity of the alignment

=item 10. B<meanMFE>

Mean minimum free energy of the single sequences as
calculated by the RNAfold algorithm

=item 11. B<consensusMFE>

``Consensus MFE" for the alignment as calculated by
the RNAalifold algorithm

=item 12. B<energyTerm>

Contribution to the consensus MFE which comes from the
energy part of the RNAalifold algorithm

=item 13. B<covarianceTerm>

Contribution to the consensus MFE which comes from
the covariance part of the RNAalifold algorithm

=item 14. B<combPerPair>

Number of different base combinations per predicted
pair in the consensus seconary structure

=item 15. B<z>

Mean z-score of the sequences in the alignment

=item 16. B<SCI>

Structure conservation index for the alignment

=item 17. B<decValue>

Support vector machine decision value

=item 18. B<P>

RNA class probability as calculated by the SVM

=item 19. B<COL#>

Specify a particular column by its index #. First column has index 1.
e.g. C<COL18E<gt>0.9> is equivalent to C<PE<gt>0.9>

=back

=head1 OPERATORS

=over 8

=item B<E<lt>,E<gt>>

Less than, greater than

=item B<==>

Equals numerically

=item B<eq>

Equals (strings)

=item B<=~/regex/>

Matches regular expression.

=item B<(, ), and, or, not>

Logical operators and grouping

=back


=head1 EXAMPLES

 # rnazFilter.pl "P>0.9 and z<-3 and seqID~=/chr13/" results.dat

Gives you all clusters with windows with P>0.9 and z<-3 on chromosome
13.

 # rnazFilter.pl -c "P>0.9" results.dat

Counts all windows/loci with P>0.9.


=head1 AUTHOR

Stefan Washietl <wash@tbi.univie.ac.at>

=cut
