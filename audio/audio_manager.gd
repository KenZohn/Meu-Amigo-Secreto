extends Node


func play_sound(sound_data: Dictionary) -> void:
	var audio := AudioStreamPlayer.new()
	
	audio.stream = sound_data["sound"]
	audio.volume_db = sound_data.get("volume", 0.0)
	
	add_child(audio)
	
	audio.finished.connect(audio.queue_free)
	audio.play()
