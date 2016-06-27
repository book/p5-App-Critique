package App::Critique::Command::status;

use strict;
use warnings;

use App::Critique::Session;

use App::Critique -command;

sub opt_spec {
    [ 'verbose|v', 'display debugging information' ]
}

sub validate_args {
    my ($self, $opt, $args) = @_;
    # ...
}

sub execute {
    my ($self, $opt, $args) = @_;

    if ( my $session = eval { App::Critique::Session->locate_session } ) {
        $self->output($self->HR_DARK);
        $self->output('CONFIG:');
        $self->output($self->HR_LIGHT);
        $self->output('  --perl-critic-profile : %s', $session->perl_critic_profile // '');
        $self->output('  --perl-critic-theme   : %s', $session->perl_critic_theme   // '');
        $self->output('  --perl-critic-policy  : %s', $session->perl_critic_policy  // '');
        $self->output('  --git-work-tree       : %s', $session->git_work_tree       // '');
        $self->output('  --git-branch          : %s', $session->git_branch          // '');
        $self->output($self->HR_DARK);
        $self->output('FILES: <legend: [r|s|e|c] path>');
        $self->output($self->HR_LIGHT);
        my ($num_files, $num_reviewed, $num_skipped, $num_edited, $num_commited) = (0,0,0,0,0);
        foreach my $file ( $session->tracked_files ) {
            $num_files++;
            $self->output('[%s|%s|%s|%s] %s',
                ($file->{reviewed} ? do { $num_reviewed++; 'r' } : '-'),
                ($file->{skipped}  ? do { $num_skipped++ ; 's' } : '-'),
                ($file->{edited}   ? do { $num_edited++  ; 'e' } : '-'),
                ($file->{commited} ? do { $num_commited++; 'c' } : '-'),
                $file->{path}->relative( $session->git_work_tree ),
            );
        }
        $self->output($self->HR_DARK);
        $self->output('TOTALS:');
        $self->output($self->HR_LIGHT);
        $self->output('  TOTAL      : %d files', $num_files );
        $self->output('  (r)eviwed  : %d', $num_reviewed );
        $self->output('  (s)kipped  : %d', $num_skipped );
        $self->output('  (e)dited   : %d', $num_edited );
        $self->output('  (c)ommited : %d', $num_commited );
        $self->output($self->HR_DARK);
        $self->output('PATH: (%s)', $session->session_file_path);
        $self->output($self->HR_DARK);
    }
    else {
        if ( $opt->verbose ) {
            $self->warning(
                'Unable to locate session file, looking for (%s)',
                App::Critique::Session->locate_session_file // 'undef'
            );
        }
        $self->runtime_error('No session file found.');
    }

}

1;

__END__

# ABSTRACT: Display status of the current critique session.

=pod

=head1 NAME

App::Critique::Command::status - Critique all the files.

=head1 DESCRIPTION

This command will display information about the current critique session.
Among other things, this will include information about each of the files,
such as:

=over 4

=item has the file been criqued already?

=item did we perform an edit of the file?

=item have any changes been commited?

=back

=cut
