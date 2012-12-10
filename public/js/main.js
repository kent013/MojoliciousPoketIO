var ws = null;

$().ready(function () {
  $('#app').on('click', '#submit_name', function(e){
    e.preventDefault();
    var data = {name: $('#name').val()};
    $.ajax({
      type: 'POST',
      data: data,
      url: '/set_name',
      dataType: 'json',
      success: function(data){
        $('span.name').text(data);
      }
    });
  });

  $('#app').on('click', '#submit_message', function(e){
    e.preventDefault();
    ws.emit('echo', $('#message').val());
  });
  initWebSocket();
});

function initWebSocket(){
  ws = io.connect();
  ws.on('connect', function(){
    ws.emit('join');
  });
  $(window).on('beforeunload', function(event) {
    ws.emit('leave');
    return;
  });

  ws.on('echo', function(data){
    $('#messages').prepend($("<p>" + data + "</p>"));
  });
}

