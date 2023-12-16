@icon("res://addons/AudioEvents/AudioEventPlayer.svg")
class_name AudioEventsStreamResource
extends Resource
## Custom resource that manages an audio file together with an array of event times
##
## Use this Resource together with an AudioEventPlayer.

@export var name : String = "Audio"
@export var audio : AudioStream
@export var eventTimes : Array[float]
