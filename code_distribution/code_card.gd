extends Control


func _on_button_pressed() -> void:
	DisplayServer.clipboard_set($CodePanel/Code.text)
