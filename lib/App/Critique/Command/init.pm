package App::Critique::Command::init;

use strict;
use warnings;

use App::Critique -command;

sub abstract    { 'Initialize .critique file.' }
sub description {
q[This command will create a critique session file your ~/.critique
directory. This file will be used to store information about the
critque session. The specific file path for the critique session
will be based on the information provided through the command line
options, and will look something like this:

 ~/.critique/<git-repo-name>/<git-branch-name>/<session-id>.json

Note that the branch name can be 'master', but must be specified
as such. The session-id can be specified on the command line, or
will be generated for you.

You must also Perl::Critic informaton must be specified, either as
a Perl::Critic profile config (ex: perlcriticrc) with additional
Perl::Critic 'theme' expression added. Alternatively you can just
specify a single Perl::Critic::Policy to use during the critique
session.
] }

sub opt_spec {
    [ 'perl-critic-profile=s', 'path to the Perl::Critic profile to use (default is to let Perl::Critic find the .perlcriticrc)' ],
    [ 'perl-critic-theme=s',   'name of a single Perl::Critic theme expression to use' ],
    [ 'perl-critic-policy=s',  'name of a single Perl::Critic policy to use (overrides -theme and -policy)' ],
    [ 'git-work-tree=s',       'path to the git working directory (default is current directory)' ],
    [ 'git-branch=s',        'name of git branch to use for critique' ],
    [ 'session-id=s',          'unique identifier for this session (default is random SHA-1)' ],
    [ 'verbose|v',             'display debugging information' ]
}

sub validate_args {
    my ($self, $opt, $args) = @_;
    # ...
}

sub execute {
    my ($self, $opt, $args) = @_;
    # ...
}

1;

__END__

=pod

=cut