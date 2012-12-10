package MojoliciousPocketIO::WebSocket;
use utf8;
use warnings;
use strict;

use DateTime;
use Mojo::JSON;
use Clone;
use MojoliciousPocketIO::WebSocketController;


sub new {
  my $class = shift;
  return bless {}, $class;
}

sub controller{
  my ($self, $session_id) = @_;
  if(!defined $session_id){
    return undef;
  }
  my $controller =
    MojoliciousPocketIO::WebSocketController->new($session_id);
  return $controller;
}

sub run{
  my $self = shift;
  return sub{
    my $socket = shift;
    my $session_id = $self->session_id($socket);
    my $controller = $self->controller($session_id);

    $socket->on(join  => sub { $controller->onJoin(@_); });
    $socket->on(leave => sub { $controller->onLeave(@_); });
    $socket->on(echo  => sub { $controller->onEcho(@_); });

    $socket->on(disconnect => sub {
      $controller->onLeave(@_);
    });
  };
}

sub session_id{
  my $self = shift;
  my $socket = shift;
  my $cookie = $socket->{conn}->{on_connect_args}[0]->{HTTP_COOKIE};
  if($cookie =~ /sid=([0-9a-f]+)/){
    return $1;
  }
  return undef;
}

1;
