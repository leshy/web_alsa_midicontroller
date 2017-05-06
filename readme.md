very simple web/websocket based midi controler with 10 sliders, using alsa MIDI

run in console

```
npm install -g livescript
lsc serverside.ls

```

open in web browser

http://localhost:4444


interface to supercollider ugen using a control bus

```sclang

// midi control bus stuff
( ~midiBus = [];
{
	var bus;
	bus = Bus.control(s,2);
	bus.set(64);
	~midiBus = ~midiBus.add(bus);
}.dup(10)
)

// midi stuff
(MIDIClient.disposeClient;
MIDIClient.init(1,0,true);
MIDIIn.connectAll;
MIDIIn.noteOff = {};
MIDIIn.noteOn = {arg src, chan, num, vel;
	postln([src,chan,num,vel]);
	~midiBus[chan].set(num);

};
)

// sample ugen
{PMOsc.ar(
	In.kr(~midiBus[0]) * 10,
	In.kr(~midiBus[1]) * 10,
	7
)}.scope;


```
