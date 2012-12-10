package MojoliciousPocketIO::Controller;

use utf8;
use warnings;
use strict;

use parent qw/Mojolicious::Controller/;

sub session {
  my $self = shift;
  my $session = $self->stash('mojox-session');

  if (@_ == 0) {
	return $session;
  }

  if (@_ == 1) {
	return $session->data($_[0]);
  }

  my %v = @_;
  $session->data(%v);
}

1;
