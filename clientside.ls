#autocompile
require! {
  leshdash: { map, times }
  'socket.io-client': io
  'zepto-browserify': { $ }
}

window.$ = $


      
$(document).ready ->
  socket = io()
  $("body").on 'touchmove', -> void


  sliders = -> 

    times 10, (n) ->   
      range = $("
      <span class='channel'>#{n}</span>
      <span class='val val#{n}'>64</span>
      <input type='range' class='range range#{n}' max='127' min='0' value='64'>
      ")
      $(document.body).append(range)

      valSpan = $(".val#{n}")

      last = 64

      handle = ->
        if (val = it.target.value) is last then return
        console.log "midi #{n}", val
        last := val
        valSpan.html val

        socket.emit 'midi', [144 + n, val, 127]
        return void

      $(".range#{n}").on 'touchmove', handle
      $(".range#{n}").on 'input', handle


  tilters = ->

    if window.DeviceOrientationEvent then

      LRel = $("<div class='val lr'/>")
      FBel = $("<div class='val fb'/>")
      DIRel = $("<div class='val dir'/>")

      $(document.body).append(LRel)
      $(document.body).append(FBel)
      $(document.body).append(DIRel)

      vals = {} 
      scale = 127 / 360
      
      window.addEventListener 'deviceorientation', (eventData) ->
        vals.lr = Math.round((eventData.gamma + 180) * scale)
        vals.fb = Math.round((eventData.beta + 180) * scale)
        vals.dir = Math.round(eventData.alpha * scale)

      oldVals = {}
                        
      setInterval do
        ->

          if oldVals.lr isnt vals.lr
            LRel.html('lr ' + vals.lr)
            socket.emit 'midi', [144, vals.lr, 127]
            oldVals.lr = vals.lr
            
          if oldVals.fb isnt vals.fb
            FBel.html('fb ' + vals.fb)
            socket.emit 'midi', [145, vals.fb, 127]
            oldVals.fb = vals.fb

          if oldVals.dir isnt vals.dir
            DIRel.html('dir ' + vals.dir)
            socket.emit 'midi', [146, vals.dir, 127]
            oldVals.dir = vals.dir
          
        1





  switch window.location.pathname
    | '/' => sliders()
    | '/tilt' => tilters()


