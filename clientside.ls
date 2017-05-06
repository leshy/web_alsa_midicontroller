#autocompile
require! {
  leshdash: { map, times }
  'socket.io-client': io
  'zepto-browserify': { $ }
}

window.$ = $
$(document).ready ->
  socket = io()

  times 10, (n) ->   
    range = $("
    <span class='channel'>#{n}</span>
    <span class='val val#{n}'>64</span>
    <input type='range' class='range range#{n}' max='127' min='0' value='64'>
    ")
    $(document.body).append(range)

    val = $(".val#{n}")
    $(".range#{n}").on 'input', ->
      console.log "midi #{n}", it.target.value
      val.html(it.target.value)
      socket.emit 'midi', [144 + n, it.target.value, 127]


