@icon("res://AudioEventPlayer.svg")
class_name AudioEventPlayer
extends Node

const PRECISION = .01

@export var audioStreamPlayer : AudioStreamPlayer
@export var audioEventStream : AudioWithEvents

signal soundEvent(soundName: String, id: int, playedAt: float)

var lastId = -1

func _ready():
	var p = get_parent()
	if audioEventStream:
		audioStreamPlayer.stream = audioEventStream.audio
	if p is AudioStreamPlayer:
		audioStreamPlayer = p
	audioStreamPlayer.play()

func _process(_delta):
	if not audioStreamPlayer or not audioEventStream:
		return
		
	if !audioStreamPlayer.playing:
		return
	
	var pos = audioStreamPlayer.get_playback_position()
	var index = -1
	for t_i in range(len(audioEventStream.eventTimes)):
		var t = audioEventStream.eventTimes[t_i]
		if abs(t - pos) <= PRECISION:
			pos = t
			index = t_i
			break
	
	if index != -1 and lastId != index:
		soundEvent.emit(audioEventStream.name, index, pos)
		lastId = index


func _on_audio_stream_player_finished():
	print("finish machine reininger")
	pass # Replace with function body.
