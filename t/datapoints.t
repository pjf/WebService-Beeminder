#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use Test::More;
use WebService::Beeminder;

if (not $ENV{AUTHOR_TESTING} ) {
    plan skip_all => 'Set $ENV{AUTHOR_TESTING} to run author tests.'
}

my $token_file = "$ENV{HOME}/.webservice-beeminder.token";
my $token;

eval {
    open(my $fh, '<', $token_file);
    local $/;
    chomp($token = <$fh>);
};

if (not $token) {
    plan skip_all => "Cannot read $token_file";
}

my $bee = WebService::Beeminder->new(token => $token);

# This test assumes we have a 'floss' goal. Dental hygiene is important!

my $data = $bee->datapoints('floss');

is(ref $data, 'ARRAY', "Datapoints returns an array of entries");

# Just make sure all the fields are there
ok($data->[0]{timestamp},       "timestamp");
ok(defined $data->[0]{comment}, "comment");
ok(defined $data->[0]{value},   "value");
ok($data->[0]{updated_at},      "updated_at");
ok($data->[0]{id},              "id");

done_testing;
