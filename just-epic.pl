use strict;
use warnings;
no feature 'indirect';

my $app = sub {
    [200, ['Content-Type' => 'text/html'], ['<h1>just epic. 2011-2022;</h1>']];
};

sub just ($) {
    require Plack::Runner;
    my $runner = Plack::Runner->new;
    $runner->parse_options(@ARGV);
    $runner->run($app);
    exit 0;
}
sub epic () { return 1 }

just epic.
2011-2022;
