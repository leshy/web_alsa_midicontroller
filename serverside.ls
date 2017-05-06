require! {
  leshdash: { map }
  ribcage
  midi
  bluebird: p
}

env = do
  settings:
    module:
      express4:
        port: 4444
        views: __dirname + '/ejs'
        static: __dirname + '/static'


initMidi = ->
  env.output = new midi.output()
  env.output.openVirtualPort("Test Output")


ribcage.init env, (err,env) ->

  initMidi()
  

  
  env.app.get '/*', (req,res) -> res.render 'index', { title: 'midi'  }

  io = require('socket.io')(env.http)

  io.on 'connection', (socket) -> socket.on 'midi', (data) -> env.output.sendMessage data

