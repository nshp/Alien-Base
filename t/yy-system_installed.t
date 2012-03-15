use strict;
use warnings;

use File::chdir;

use Test::More;
use Alien::Base::ModuleBuild;

local $CWD;
push @CWD, qw/t system_installed/;

my $skip;
system( 'pkg-config --version' );
if ( $? ) {
  plan skip_all => "Cannot use pkg-config: $?";
}

my @installed = map { /^(\S+)/ ? $1 : () } `pkg-config --list-all`;
my $lib = $installed[0];

my $cflags = `pkg-config --cflags $lib`;
my $libs = `pkg-config --libs $lib`;

my $builder = Alien::Base::ModuleBuild->new( 
  module_name => 'MyTest', 
  dist_version => 0.01,
  alien_name => $lib,
  share_dir => 't',
); 

$builder->depends_on('build');

{
  local $CWD;
  push @CWD, qw/blib lib/;

  require MyTest;
  my $alien = MyTest->new;

  isa_ok($alien, 'MyTest');
  isa_ok($alien, 'Alien::Base');

  is($alien->cflags, $cflags, "get cflags from system-installed library");
  is($alien->libs  , $libs  , "get libs from system-installed library"  );
}

$builder->depends_on('realclean');

done_testing;

