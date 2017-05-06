(function(){
  var ref$, map, times, io, $;
  ref$ = require('leshdash'), map = ref$.map, times = ref$.times;
  io = require('socket.io-client');
  $ = require('zepto-browserify').$;
  window.$ = $;
  $(document).ready(function(){
    var socket, sliders, tilters;
    socket = io();
    $("body").on('touchmove', function(){});
    sliders = function(){
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
    };
    tilters = function(){
      var LRel, FBel, DIRel, vals, scale, oldVals;
      if (window.DeviceOrientationEvent) {
        LRel = $("<div class='val lr'/>");
        FBel = $("<div class='val fb'/>");
        DIRel = $("<div class='val dir'/>");
        $(document.body).append(LRel);
        $(document.body).append(FBel);
        $(document.body).append(DIRel);
        vals = {};
        scale = 127 / 360;
        window.addEventListener('deviceorientation', function(eventData){
          vals.lr = Math.round((eventData.gamma + 180) * scale);
          vals.fb = Math.round((eventData.beta + 180) * scale);
          return vals.dir = Math.round(eventData.alpha * scale);
        });
        oldVals = {};
        return setInterval(function(){
          if (oldVals.lr !== vals.lr) {
            LRel.html('lr ' + vals.lr);
            socket.emit('midi', [144, vals.lr, 127]);
            oldVals.lr = vals.lr;
          }
          if (oldVals.fb !== vals.fb) {
            FBel.html('fb ' + vals.fb);
            socket.emit('midi', [145, vals.fb, 127]);
            oldVals.fb = vals.fb;
          }
          if (oldVals.dir !== vals.dir) {
            DIRel.html('dir ' + vals.dir);
            socket.emit('midi', [146, vals.dir, 127]);
            return oldVals.dir = vals.dir;
          }
        }, 1);
      }
    };
    switch (window.location.pathname) {
    case '/':
      return sliders();
    case '/tilt':
      return tilters();
    }
  });
}).call(this);
