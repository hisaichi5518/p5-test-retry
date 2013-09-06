use strict;
use warnings;
use Test::More;
use Test::Retry;

my $i = 0;
subtest "retry" => retry 5, 1, sub {
    pass;
    fail "but ok" if $i < 3;
    pass;
    $i++;
};

done_testing;
