(function(){
  var ref$, map, times, io, $;
  ref$ = require('leshdash'), map = ref$.map, times = ref$.times;
  io = require('socket.io-client');
  $ = require('zepto-browserify').$;
  window.$ = $;
  $(document).ready(function(){
    var socket;
    socket = io();
    return times(10, function(n){
      var range, val;
      range = $("<span class='channel'>" + n + "</span><span class='val val" + n + "'>64</span><input type='range' class='range range" + n + "' max='127' min='0' value='64'>");
      $(document.body).append(range);
      val = $(".val" + n);
      return $(".range" + n).on('input', function(it){
        console.log("midi " + n, it.target.value);
        val.html(it.target.value);
        return socket.emit('midi', [144 + n, it.target.value, 127]);
      });
    });
  });
}).call(this);
