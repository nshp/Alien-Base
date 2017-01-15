package Alien::Base::ModuleBuild::Cabinet;

use strict;
use warnings;

our $VERSION = '0.030_01';
$VERSION = eval $VERSION;

use Sort::Versions;

sub new {
  my $class = shift;
  my $self = ref $_[0] ? shift : { @_ };

  bless $self, $class;

  return $self;
}

sub files { shift->{files} }

sub add_files {
  my $self = shift;
  push @{ $self->{files} }, @_;
  return $self->files;
}

sub sort_files {
  my $self = shift;

  $self->{files} = [
    sort {
      $a->has_version
        ? ($b->has_version ? versioncmp($b->version, $a->version) : -1)
        : ($b->has_version ? 1 : version($b->filename, $a->filename))
    } @{ $self->{files} }
  ];

  return;
}

1;

