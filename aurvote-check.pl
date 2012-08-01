#!/usr/bin/perl

use warnings;
use strict;

use Term::ANSIColor;

# ====================================== #

my %colors = (
    "Info" => 'white',
    "Error" => 'bold red',
    "Success" => 'bold green',
    "PkgNum" => 'bold cyan',
    "PkgRepo" => 'bold yellow',
    "PkgName" => 'bold green',
    "PkgVer" => 'blue',
    "Voted" => 'green',
    "NotVoted" => 'red',
    "NotAUR" => 'magenta',
    "Changing" => 'bold white',
);

# ====================================== #


## Retrieve package list
print color $colors{"Info"};
print "Getting list of foreign (AUR) packages...\n";
print color 'reset';
my $packages = `pacman -Qm`;
#my $packages = "asd 1.0\ndropbox 4.0\ngnome-activity-journal 1.0\n";
$packages =~ s/(.*) (.*)\n/$1 $2;/g;
my %version = split(/[ ;]/, $packages);
my %votes = ();
my @packages = sort keys %version;



## List and check vote state for packages
my $i = 1;
print color $colors{"Info"};
print "Checking vote state for packages:\n\n";
print color 'reset';
foreach my $package (@packages) {

    print color $colors{PkgNum};
    print $i++, ") ";
    print color 'reset';

    print color $colors{PkgRepo};
    print "local/";
    print color 'reset';

    print color $colors{PkgName};
    print "$package ";
    print color 'reset';

    print color $colors{PkgVer};
    print "($version{$package}) ";
    print color 'reset';

    print color $colors{Info};
    print " => ";
    print color 'reset';

    my $vote = `aurvote -c $package`;
    chomp $vote;

    if ($vote) {
        if ($vote =~ /not/) {
            print color $colors{NotVoted};
        }
        else {
            print color $colors{Voted};
        }
    }
    else {
        print color $colors{NotAUR};
        $vote = "not found on AUR";
    }

    $votes{$package} = $vote;
    print $vote , "\n";
    print color 'reset';
}


## Ask for packages to change the vote
print color $colors{Info};
print "\nWhich packages do you want to change the vote of? ";
print color 'reset';

## Change the votes
chomp(my $list = <>);
$list =~ s/[^0-9\s-]//g;
print "\n";
if ($list) {
    my @pkgs = split(' ', $list);
    for my $pkgNum (@pkgs) {
        $pkgNum--;
       
        # Check if number is valid and package is from AUR 
        next if ($pkgNum < 0 or $pkgNum >= @packages);
        if ($votes{$packages[$pkgNum]} =~ /AUR/) {
            print color $colors{Changing};
            print "Skipping ";
            print color 'reset';
        
            print color $colors{PkgRepo};
            print "local/";
            print color 'reset';
            
            print color $colors{PkgName};
            print $packages[$pkgNum];
            print color 'reset';
            
            print color $colors{Error};
            print " (Not in AUR)\n";
            print color 'reset';

            next;
        }
       
        print color $colors{Changing};
        print "Changing vote for ";
        print color 'reset';
        
        print color $colors{PkgName};
        print $packages[$pkgNum];
        print color 'reset';

        print color $colors{Changing};
        print " to ";
        print color 'reset';

        ## Find out new vote state
        my $newVote = "-u";
        if ($votes{$packages[$pkgNum]} =~ /not/) {
            $newVote = "-v";
            print color $colors{Voted};
            print "Voted";
            print color 'reset';
        }
        else {
            print color $colors{NotVoted};
            print "Not Voted";
            print color 'reset';
        }

        print color $colors{Changing};
        print "...  ";
        system("aurvote $newVote $packages[$pkgNum]");
        print "[DONE]\n";
        print color 'reset';
    }

    print "\n";
} 
