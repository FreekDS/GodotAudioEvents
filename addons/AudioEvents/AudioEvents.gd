@tool
extends EditorPlugin


const RESOURCE = preload("res://addons/AudioEvents/scripts/AudioFileWithEvents.gd")
const NODE_TYPE = preload("res://addons/AudioEvents/scripts/AudioStreamPlayerEvents.gd")
const ICON = preload("res://addons/AudioEvents/AudioEventPlayer.svg")

const NODE_PARENT = "AudioStreamPlayer"
const NODE_NAME = "AudioEventPlayer"

const RES_PARENT = "AudioStream"
const RES_NAME = "AudioWithEvents"


func _enter_tree():
	add_custom_type(NODE_NAME, NODE_PARENT , NODE_TYPE, ICON)
	add_custom_type(RES_NAME, RES_PARENT, RESOURCE, ICON)


func _exit_tree():
	remove_custom_type(NODE_NAME)
	remove_custom_type(RES_NAME)
