package MojoliciousPocketIO::Main;
use utf8;
use warnings;
use strict;

use parent qw/MojoliciousPocketIO::Controller/;
use Data::Dumper;

sub top {
  my $self = shift;
  $self->session('room_id', 'ika');
  my $name = $self->session('name');
  if(!$name){
    $name = 'anonymous';
  }
  $self->stash('name', $name);
  $self->render();
}

sub set_name{
  my $self = shift;
  my $name = $self->param('name');
  $self->session(name => $name);
  $self->render(json => $name);
}

1;
