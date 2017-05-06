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


