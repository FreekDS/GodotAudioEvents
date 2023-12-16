extends Node

func _on_audio_event_player_sound_event(soundName, id, at):
	print(soundName," ", id, " ", at)
