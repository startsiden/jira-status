package JIRA::Status::App::Command::store_events;
use Moose;

extends qw(JIRA::Status::App::Command);


use JIRA::Status::Web::Types qw/ArrayOfEventSources/;
use MooseX::Types::DateTime qw(DateTime);

use JIRA::Status::Data::Events::EventSet;
use JIRA::Status::Data::Events::EventSource;

has 'sources' => (
    traits => [qw/Array/],
    is => 'ro',
    isa => ArrayOfEventSources,
    coerce => 1,
    default => sub {[]},
    handles => {
        'all_sources' => 'elements',
        '_grep_sources' => 'grep',
    },
);

sub execute {
    my ($self) = @_;
    my $scope = $self->db->new_scope;

    my $events = JIRA::Status::Data::Events::EventSet->new();

    foreach my $source ($self->all_sources) {
        foreach my $event ($source->events) {
            $events->add_event($event);

        }

    }    
    $self->db->store_eventset($events);
}


1;