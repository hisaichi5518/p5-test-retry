package Test::Retry;
use 5.008005;
use strict;
use warnings;

our $VERSION = "0.01";
use parent "Exporter";

our @EXPORT = qw(retry);

sub retry {
    my ($times, $delay, $code) = @_;
    sub {
        my $builder = Test::Builder->new;

        my $old_test_results = $builder->{Test_Results};
        my $old_curr_test    = $builder->{Curr_Test};

        for my $i (1..$times) {
            eval { $code->() };
            my $new_test_results = $builder->{Test_Results};
            my $new_curr_test    = $builder->{Curr_Test};
            my @new_failed_num   = grep { !$_->{'ok'} } @{$new_test_results}[ 0 .. $new_curr_test - 1 ];

            if ($@ || scalar(@new_failed_num)) {
                $builder->diag($@) if $@;

                # rollback
                $builder->{Test_Results} = $old_test_results;
                $builder->{Curr_Test}    = $old_curr_test;
                next;
            }

            $builder->is_passing(1);
            return 1;
        }

    };
}

1;
__END__

=encoding utf-8

=head1 NAME

Test::Retry - It's new $module

=head1 SYNOPSIS

    use Test::Retry;

=head1 DESCRIPTION

Test::Retry is ...

=head1 LICENSE

Copyright (C) hisaichi5518.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

hisaichi5518 E<lt>hisada.kazuki@gmail.comE<gt>

=cut

