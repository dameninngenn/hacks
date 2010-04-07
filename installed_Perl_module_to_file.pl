#!/usr/bin/perl

# from PerlHacks O'REILLY

use strict;
use warnings;
use File::Find 'find';

my $LIST_DIR = "$ENV{HOME}/.vim/dict/";
my $LIST_FILE = 'installed_Perl_module';

unless(-e $LIST_DIR){
    mkdir $LIST_DIR
        or die "Couldn't create directory $LIST_DIR ($!)\n";
}

open my $fh,'>',"$LIST_DIR$LIST_FILE"
    or die "Couldn't create file '$LIST_FILE' ($!)\n";

my %already_seen;

for my $incl_dir (@INC){
    find{
        wanted => sub{
            my $file = $_;

            return unless $file =~ /\.pm\z/;

            $file =~ s{^\Q$incl_dir/\E}{};
            $file =~ s{/}{::}g;
            $file =~ s{\.pm\z}{};

            $file =~ s{^.*\b[a-z_0-9]+::}{};
            $file =~ s{^\d+\.\d+\.\d+::(?:[a-z_][a-z_0-9]*::)?}{};
            return if $file =~ m{^::};

            print {$fh} $file, "\n" unless $already_seen{$file}++;
        },
        no_chdir => 1,
    }, $incl_dir;
}

