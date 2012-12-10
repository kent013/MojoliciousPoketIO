use utf8;
use warnings;
use strict;

use Mojo::Server::PSGI;
use File::Spec;
use File::Basename;
use Plack::Builder;
use Plack::App::File;
use PocketIO;

use FindBin;
use lib "$FindBin::Bin/../lib";
use MojoliciousPocketIO;
use PocketIO::Resource;
use MojoliciousPocketIO::WebSocket;

my $psgi = Mojo::Server::PSGI->new( app => MojoliciousPocketIO->new );
my $app = sub { $psgi->run(@_) };

my $siroot = "$FindBin::Bin/../public/js/";

builder {
  mount '/socket.io/socket.io.js' =>
    Plack::App::File->new(file => "$siroot/socket.io.js");
  mount '/socket.io/static/flashsocket/WebSocketMain.swf' =>
    Plack::App::File->new(file => "$siroot/WebSocketMain.swf");
  mount '/socket.io/static/flashsocket/WebSocketMainInsecure.swf' =>
    Plack::App::File->new(file => "$siroot/WebSocketMainInsecure.swf");
  mount '/socket.io' =>
    PocketIO->new( class => 'MojoliciousPocketIO::WebSocket', method => 'run' );
  mount '/' => $app;
};
