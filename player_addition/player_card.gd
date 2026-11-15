extends Control

signal deleted
signal enter_pressed

const ALPHABET := "ABCDEFGHIJKLMNOPQRSTUVWXYZÁÀÂÃÉÊÍÓÔÕÚÇabcdefghijklmnopqrstuvwxyzáàâãéêíóôõúç 0123456789-'."


func set_number(number: int) -> void:
	$Number.text = str(number) + "."


func focus_name() -> void:
	$Name.grab_focus()


func _on_button_pressed() -> void:
	deleted.emit()
	queue_free()


func _on_name_text_submitted(_text: String) -> void:
	if not $Name.text.strip_edges().is_empty():
		AudioManager.play_sound(Audio.CONFIRM)
		enter_pressed.emit()


func _on_name_text_changed(new_text: String) -> void:
	var filtered_text := ""
	
	for character in new_text:
		if character in ALPHABET:
			filtered_text += character
	
	if new_text != filtered_text:
		$Name.text = filtered_text
		$Name.caret_column = filtered_text.length()
