package MojoliciousPocketIO;
use utf8;
use warnings;
use strict;

use Data::Dumper;
use MojoliciousPocketIO::Controller;
use Mojo::Base 'Mojolicious';
#use MojoX::Session::Transport::Cookie;

sub startup {
  my $self = shift;
  $self->setup_app;
  $self->build_routes;
}

sub build_routes{
  my $self = shift;
  my $r = $self->routes;
  $r->post('/set_name')->to('main#set_name');
  $r->get('/')->to('main#top');
}

sub setup_app{
  my $self = shift;
  $self->plugin('PODRenderer');

  my $config =
    $self->plugin('Config',
                  {file => $self->app->home->rel_file('conf/app.conf')});
  $self->secret($config->{secret});
  $self->controller_class('MojoliciousPocketIO::Controller');

  my $handler = DBIx::Handler->new(
    $config->{db_dsn},
    $config->{db_username},
    $config->{db_password},
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

  $self->plugin(
	session => {
	  stash_key => 'mojox-session',
	  store     => [dbi => {dbh => $handler->dbh}],
	  transport => 'cookie',
	  expires_delta => 1209600, #2 weeks.
	  init      => sub{
		my ($self, $session) = @_;
		$session->load;
		if(!$session->sid){
		  $session->create;
		}
	  },
	}
  );
}

1;
