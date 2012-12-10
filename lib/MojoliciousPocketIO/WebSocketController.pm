package MojoliciousPocketIO::WebSocketController;
use utf8;
use warnings;
use strict;

use Data::Dumper;
use Clone;
use PocketIO;
use DBIx::Handler;

sub new {
  my ($class, $session_id) = @_;
  my $self = {
    session_id => $session_id
  };
  bless $self, $class;
  return $self;
}

#load config file from 'conf/app.conf'
sub config{
  my $self = shift;
  if($self->{config}){
    return $self->{config};
  }
  my $file = 'conf/app.conf';
  open my $handle, "<:encoding(UTF-8)", $file
    or die qq{Couldn't open config file "$file": $!};
  my $content = do { local $/; <$handle> };

  my $config = eval 'package Mojolicious::Plugin::Config::Sandbox;'
    . "no warnings; use Mojo::Base -strict; $content";
  die qq{Couldn't load configuration from file "$file": $@} if !$config && $@;
  die qq{Config file "$file" did not return a hash reference.\n}
    unless ref $config eq 'HASH';

  $self->{config} = $config;
}

sub session{
  my $self = shift;
  if(!defined $self->{session}){
    my $handler = DBIx::Handler->new(
      $self->config->{db_dsn},
      $self->config->{db_username},
      $self->config->{db_password},
      +{
        mysql_auto_reconnect => 1,
        mysql_enable_utf8 => 1,
        RaiseError => 1,
        PrintError => 0,
        AutoCommit => 1,
        on_connect_do => [
          "SET NAMES 'utf8'",
          "SET CHARACTER SET 'utf8'",
        ],
      },
    );
    my $session = MojoX::Session->new(
	  store     => [dbi => {dbh => $handler->dbh}],
	  transport => 'cookie',
	  expires_delta => 1209600, #2 weeks.
    );
    $session->load($self->session_id);
    $self->{session} = $session;
  }

  my $session = $self->{session};
  if (@_ == 0) {
	return $session;
  }

  if (@_ == 1) {
	return $session->data($_[0]);
  }

  my %v = @_;
  $session->data(%v);
}

sub session_id{
  return shift->{session_id};
}

sub onJoin{
  my ($self, $socket, $message) = @_;
  my $room = $self->session('room_id');
  $socket->join($room);
}

sub onLeave{
  my ($self, $socket, $message) = @_;
  my $room = $self->session('room_id');
  $socket->leave($room);
}

sub onEcho{
  my ($self, $socket, $message) = @_;
  my $room = $self->session('room_id');
  my $name = $self->session('name');
  $socket->sockets->in($room)->emit('echo', $name . ' says ' . $message);
}

1;
