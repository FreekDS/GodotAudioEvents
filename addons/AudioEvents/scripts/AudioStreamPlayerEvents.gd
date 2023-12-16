@icon("res://addons/AudioEvents/AudioEventPlayer.svg")
extends Node
## The AudioEventPlayer node is used to manage audio with events.
##
## Attach an AudioEventStream resource to the Audio Event Stream field and
## Attach an audio stream player
## If no stream player is attached, then the script will try to use the parent as
## AudioStreamPlayer.

const PRECISION = .01

@export var audioStreamPlayer : AudioStreamPlayer
@export var audioEventStream : AudioEventsStreamResource

signal soundEvent(soundName: String, id: int, playedAt: float)

var lastId = -1

func _ready():
	var p = get_parent()
	if p is AudioStreamPlayer:
		audioStreamPlayer = p
	if audioStreamPlayer == null:
		push_error("Please assign AudioStreamPlayer, or make sure the parent is one!")
		assert(false)
		
	if audioEventStream:
		audioStreamPlayer.stream = audioEventStream.audio
		if audioStreamPlayer.autoplay:
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
		lastId = index	# Avoid doubles
