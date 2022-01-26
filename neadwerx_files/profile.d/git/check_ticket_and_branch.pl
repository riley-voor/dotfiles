#!/usr/bin/perl

use utf8;
use strict;
use warnings;
use feature qw( say );

use JIRA::REST;
use Data::Dumper;
use Getopt::Long;
use JSON::Tiny qw( decode_json );
use vars qw( $jira $ticket $git_branch );
use constant{
    FALSE => 0,
    TRUE  => 1,
};

#### COMMAND LINE ####

sub parse_args
{
    # set defaults
    $ticket = "";
    $git_branch = "";

    # get options
    GetOptions (
        "t=s" => \$ticket,
        "b=s" => \$git_branch,
    ) or die;

    die if( $ticket eq "" or $git_branch eq "" );
}

######### FUNCTIONS ############

sub check_ticket_and_branch
{
    my $issue = $jira->GET("/issue/$ticket");

    my $fields       = $issue->{'fields'};
    my $issue_branch = $fields->{'customfield_10400'} || "";

    # trim whitespace
    $issue_branch =~ s/^\s+|\s+$//g;

    say "$issue_branch";

    # check that the ticket and branch match
    if( $git_branch eq $issue_branch )
    {
        return TRUE;
    }

    return FALSE;
}

############ MAIN PROGRAM ############
parse_args();

# Create the JIRA client for the REST API
my $creds = decode_json( `get_credentials jira` );
$jira     = JIRA::REST->new($creds->{api}, $creds->{username}, $creds->{password});

my $retval = check_ticket_and_branch();

exit 1 if( $retval == FALSE );

exit 0;
