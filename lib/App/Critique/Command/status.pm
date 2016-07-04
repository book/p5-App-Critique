package App::Critique::Command::status;

use strict;
use warnings;

use App::Critique::Session;

use App::Critique -command;

sub execute {
    my ($self, $opt, $args) = @_;

    my $session = App::Critique::Session->locate_session(
        sub { $self->handle_session_file_exception('load', @_, $opt->debug) }
    );

    if ( $session ) {

        my @tracked_files = sort { $a->path cmp $b->path } $session->tracked_files;
        my $num_files     = scalar @tracked_files;

        my ($violations, $reviewed, $edited) = (0, 0, 0);
        foreach my $file ( @tracked_files ) {
            $violations += $file->recall('violations') if defined $file->recall('violations');
            $reviewed   += $file->recall('reviewed')   if defined $file->recall('reviewed');
            $edited     += $file->recall('edited')     if defined $file->recall('edited');
        }

        if ( $opt->verbose ) {
            output(HR_DARK);
            output('CONFIG:');
            output(HR_LIGHT);
            output('  perl_critic_profile : %s', $session->perl_critic_profile // 'auto');
            output('  perl_critic_theme   : %s', $session->perl_critic_theme   // 'auto');
            output('  perl_critic_policy  : %s', $session->perl_critic_policy  // 'auto');
            output('  git_work_tree       : %s', $session->git_work_tree       // 'auto');
            output('  git_branch          : %s', $session->git_branch          // 'auto');
            output(HR_DARK);
            output('FILES: <legend: [v|r|e] path>');
            output(HR_LIGHT);
            foreach my $file ( @tracked_files ) {
                output('[%s|%s|%s] %s',
                    $file->recall('violations') // '-',
                    $file->recall('reviewed')   // '-',
                    $file->recall('edited')     // '-',
                    $file->relative_path( $session->git_work_tree ),
                );
            }
        }

        output(HR_DARK);
        output('TOTAL: %d files', $num_files );
        output('  (v)iolations : %d', $violations);
        output('  (r)eviwed    : %d', $reviewed  );
        output('  (e)dited     : %d', $edited    );
        output(HR_LIGHT);
        output('PATH: (%s)', $session->session_file_path);
        output(HR_DARK);
    }
    else {
        if ( $opt->verbose ) {
            warning(
                'Unable to locate session file, looking for (%s)',
                App::Critique::Session->locate_session_file // 'undef'
            );
        }
        runtime_error('No session file found, perhaps you forgot to call `init`.');
    }

}

1;

__END__

# ABSTRACT: Display status of the current critique session.

=pod

=head1 NAME

App::Critique::Command::status - Display status of the current critique session.

=head1 DESCRIPTION

This command will display information about the current critique session.
Among other things, this will include information about each of the files,
such as how many violations were found, how many of those violations were
reviewed, and how many were edited.

=cut
