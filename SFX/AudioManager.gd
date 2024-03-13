extends Node

var num_players = 20
var bus = "master"

var available = []  ## The available players.
var queue = []  ## The queue of sounds to play.

var sounds_dict = {}

func _ready():
	#pause_mode = PAUSE_MODE_PROCESS
	## Create the pool of AudioStreamPlayer nodes.
	for i in num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available.append(p)
		p.finished.connect(_on_stream_finished.bind(p))
		#p.connect("finished", self, "_on_stream_finished", [p])
		p.bus = bus

func _on_stream_finished(stream):
	## When finished playing a stream, make the player available again.
	available.append(stream)

func play(sound_path):
	queue.append(sound_path)

func _process(delta):
	## Play a queued sound if any players are available.
	if !queue.is_empty() && !available.is_empty():
		var sound_path = queue.pop_front()
		var stream_to_play :AudioStreamPlayer
		if sounds_dict.has(sound_path):
			#sounds_dict[sound_path].play()
			stream_to_play = sounds_dict[sound_path]
		else:
			#available[0].stream = load(sound_path)
			#available[0].play()
			stream_to_play = available.pop_front()
			stream_to_play.stream = load(sound_path)
			sounds_dict[sound_path] = stream_to_play
		if stream_to_play && !stream_to_play.playing:
			#stream_to_play.stop()
			stream_to_play.play()
		
		#var new_stream = load(queue.pop_front())
		#for player in get_children():
			#print(player.stream._get_stream_name())
			##if player.stream == new_stream
		##available[0].stream = load(queue.pop_front())
		#available[0].stream = new_stream
		#available[0].play()
		#available.pop_front()
