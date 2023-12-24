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

#region Public API
## Reset the AudioEventPlayer. Makes sure that all events will be played
## when starting again.
func reset():
	lastId = -1


func play():
	if not _precondition("Cannot call play()"):
		return
	
	# Resume if it was paused
	if audioStreamPlayer.stream_paused:
		audioStreamPlayer.stream_paused = false
		return
		
	# Else reset and start again
	reset()
	audioStreamPlayer.stream = audioEventStream.audio
	audioStreamPlayer.play()

func pause():
	if not _precondition("Cannot call pause()"):
		return
	
	if audioStreamPlayer.playing:
		audioStreamPlayer.stream_paused = true

func stop():
	if not _precondition("Cannot call stop()"):
		return
	reset()
	audioStreamPlayer.stop()

#endregion

#region Godot callbacks
func _ready():
	if audioStreamPlayer == null:
		var p = get_parent()
		if p is AudioStreamPlayer:
			audioStreamPlayer = p
	if audioStreamPlayer == null:
		push_error("Please assign AudioStreamPlayer, or make sure the parent is one!")
		assert(false)
	
	audioStreamPlayer.finished.connect(reset)
	
	if audioEventStream:
		audioStreamPlayer.stream = audioEventStream.audio
		if audioStreamPlayer.autoplay and not audioStreamPlayer.playing:
			audioStreamPlayer.play()

func _process(_delta):
	if not audioStreamPlayer or not audioEventStream:
		return
		
	if !audioStreamPlayer.playing:
		return
	
	# Make sure to only call events from this AudioEventPlayer
	# in case multiple AudioEventStreams are using a single AudioStreamPlayer
	# see issue #3
	if audioStreamPlayer.stream != audioEventStream.audio:
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
		
#endregion

#region Private API
func _precondition(err: String) -> bool:
	if audioStreamPlayer == null:
		push_error(err + ": ", "AudioStreamPlayer is not assigned")
		return false
	if audioEventStream == null:
		push_error(err + ": ", "No AudioEventStream resource attached!")
		return false
	return true
	
#endregion

