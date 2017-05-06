(function(){
  var ref$, map, times, io, $;
  ref$ = require('leshdash'), map = ref$.map, times = ref$.times;
  io = require('socket.io-client');
  $ = require('zepto-browserify').$;
  window.$ = $;
  $(document).ready(function(){
    var socket;
    socket = io();
    $("body").on('touchmove', function(){});
    return times(10, function(n){
      var range, valSpan, last, handle;
      range = $("<span class='channel'>" + n + "</span><span class='val val" + n + "'>64</span><input type='range' class='range range" + n + "' max='127' min='0' value='64'>");
      $(document.body).append(range);
      valSpan = $(".val" + n);
      last = 64;
      handle = function(it){
        var val;
        if ((val = it.target.value) === last) {
          return;
        }
        console.log("midi " + n, val);
        last = val;
        valSpan.html(val);
        socket.emit('midi', [144 + n, val, 127]);
      };
      $(".range" + n).on('touchmove', handle);
      return $(".range" + n).on('input', handle);
    });
  });
}).call(this);
