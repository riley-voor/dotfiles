#!/usr/bin/perl

#### STRICTURES ####
use strict;
use warnings;
use feature qw( state say );

#### NEADWERX MODULES ####
use Carp;
use Readonly;
use Perl6::Export::Attrs;
use English qw( -no_match_vars );
use Fatal qw( open );
use Params::Validate qw( :all );

#### INTERNAL MODULES ####

#### CPAN MODULES ####
use Getopt::Long;
use JIRA::REST;
use JSON::Tiny qw( decode_json );

#### READONLYS ####
Readonly my $FALSE                    => 0;
Readonly my $TRUE                     => 1;
Readonly my $SECONDS_TO_HOURS_DIVISOR => 3600;

use vars qw( $EPIC_ID );

#### PRIVATE SUBROUTINES ####

# Prints the message and usage information.
# Params   : message (string)
# Comments : Exits with status code -1
sub _usage($)
{
    my ( $message ) = validate_pos( @_, { type => SCALAR, default => '' } );

    say "$message";
    say "Usage: $PROGRAM_NAME <EPIC_ID>";

    exit -1;
}

# Parses the command line for arguments and options.
sub _parse_command_line
{
    my $show_help = $FALSE;

    GetOptions(
        '<>'       => \&_parse_arg,
        'h|help'   => \$show_help
    ) or _usage( 'Failed to parse command line arguments.' );

    if( $show_help == $TRUE )
    {
        _usage( '' );
    }

    unless( $EPIC_ID )
    {
        _usage( 'Missing required epic id.' );
    }

    return;
}

# Handler for the epic id from the command line.
# Params   : arg (getopts)
sub _parse_arg($)
{
    my ( $arg ) = validate_pos( @_, 1 );

    state $num_args_parsed = 1;

    if( $num_args_parsed >= 2 )
    {
        _usage( 'Only one epic may be summarized at a time.' );
    }

    $EPIC_ID = $arg;

    return;
}

# Returns a single issue from a search result using JIRA JQL.
# Returns  : issue (hashref)
# Params   : jira (JIRA::REST), jql (string)
sub _get_issue($$)
{
    my ( $jira, $jql ) = validate_pos( @_, { type => HASHREF }, { type => SCALAR } );

    my $search = $jira->POST(
        '/search',
        undef,
        {
            jql        => $jql,
            startAt    => 0,
            maxResults => 1,
            fields     => [],
        }
    );

    return $search->{'issues'}[0];
}

# Returns an array of issues from a search result using JIRA JQL.
# Returns  : issues (arrayref)
# Params   : jira (JIRA::REST), jql (string)
sub _get_issues($$)
{
    my ( $jira, $jql ) = validate_pos( @_, { type => HASHREF }, { type => SCALAR } );

    my $search = $jira->POST(
        '/search',
        undef,
        {
            jql        => $jql,
            startAt    => 0,
            maxResults => 100,    # may truncate
            fields     => [],
        }
    );

    return $search->{'issues'};
}

# Turns seconds into hours as a float.
# Returns  : hours (float)
# Params   : seconds (int)
sub _seconds_to_hours($)
{
    my ( $seconds ) = validate_pos( @_, { type => SCALAR } );

    my $hours = ( $seconds / $SECONDS_TO_HOURS_DIVISOR );

    return $hours;
}

# Generates a hash of hours by role for the epic and its stories.
# Returns  : summary_hash (hashref)
# Params   : epic (hashref), stories (arrayref)
sub _generate_hours_summary_hash($$)
{
    my ( $epic, $stories ) = validate_pos( @_, { type => HASHREF }, { type => ARRAYREF } );
    
    my $summary_hash;

    # get the epic hours logged
    # assume no time spent if it's missing from the epic.
    my $epic_timespent_seconds = 0;
    if( $epic->{fields}{timespent} )
    {
        $epic_timespent_seconds = $epic->{fields}{timespent};
    }

    # add the epic time to the hash
    $summary_hash->{epic_hours} = _seconds_to_hours( $epic_timespent_seconds );

    $summary_hash->{project} = $epic->{fields}{project}{name} || "";
    $summary_hash->{customer} = $epic->{fields}{customfield_10403}[0]{value} || "";
    $summary_hash->{epic_name} = $epic->{fields}{customfield_10009} || "";
    $summary_hash->{epic_branch} = $epic->{fields}{customfield_10400} || "";
    $summary_hash->{epic_key} = $epic->{key} || "";
    $summary_hash->{innotas} = $epic->{field}{customfield_11601} || "";

    chomp $summary_hash->{project};
    chomp $summary_hash->{customer};
    chomp $summary_hash->{epic_name};
    chomp $summary_hash->{epic_branch};
    chomp $summary_hash->{epic_key};
    chomp $summary_hash->{innotas};

    # for each story:
    #   - determine time spent
    #   - determine role/s to log time to
    #   - add time to hash
    for my $story (@$stories)
    {
        # get the story hours logged
        # assume no time spent if it's missing from the story.
        my $story_timespent_seconds = 0;
        if( $story->{fields}{timespent} )
        {
            $story_timespent_seconds = $story->{fields}{timespent};
        }

        my $story_role = 'N/A';
        if( $story->{fields}{customfield_11400} )
        {
            # assume the first role is correct if more than one role exists
            $story_role = $story->{fields}{customfield_11400}[0]{value};
        }

        # create the role key if it doesn't exist yet
        unless( $summary_hash->{$story_role} )
        {
            $summary_hash->{$story_role} = 0;
        }

        # add time to hash
        $summary_hash->{$story_role} += _seconds_to_hours( $story_timespent_seconds );
    }

    return $summary_hash;
}

#### MAIN PROGRAM ####
_parse_command_line();

my $creds = decode_json( `get_credentials jira` );
my $jira  = JIRA::REST->new( $creds->{api}, $creds->{username}, $creds->{password} );

# get the epic, test if it is an epic
my $jql_epic = "key = $EPIC_ID and type = Epic";
my $epic = _get_issue( $jira, $jql_epic );

unless( $epic )
{
    say "Could not find an epic with id $EPIC_ID";
    exit 1;
}

# get the children stories for the epic
my $jql_stories = "type = Story and 'Epic Link' = $EPIC_ID";
my $stories = _get_issues( $jira, $jql_stories );

unless( $stories )
{
    say "Could not find any related stories for $EPIC_ID";
    exit 1;
}

my $hours_summary_hash = _generate_hours_summary_hash( $epic, $stories );

say 'Project Name,Affected Customer,Epic Name,Epic Key,Innotas Id,Epic Branch';
print $hours_summary_hash->{project};
print ",";
print $hours_summary_hash->{customer};
print ",";
print $hours_summary_hash->{epic_name};
print ",";
print $hours_summary_hash->{epic_key};
print ",";
print $hours_summary_hash->{innotas};
print ",";
print $hours_summary_hash->{epic_branch};
print "\n";
print "\n";

# print the summary
say 'Role,Timespent in Hours';
while( my ( $key, $value ) = each %$hours_summary_hash )
{
    next if( $key =~ /project/ );
    next if( $key =~ /customer/ );
    next if( $key =~ /epic_name/ );
    next if( $key =~ /epic_key/ );
    next if( $key =~ /innotas/ );
    next if( $key =~ /epic_branch/ );
    say "$key,$value";
}

exit 0;
