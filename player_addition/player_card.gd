extends Control

signal deleted
signal enter_pressed


func set_number(number: int) -> void:
	$Number.text = str(number) + "."


func _on_name_text_submitted(_text: String) -> void:
	if not $Name.text.strip_edges().is_empty():
		AudioManager.play_sound(Audio.CONFIRM)
		
		enter_pressed.emit()


func _on_button_pressed() -> void:
	deleted.emit()
	
	queue_free()
