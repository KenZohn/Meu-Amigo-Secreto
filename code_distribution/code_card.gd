extends Control


func _on_button_pressed() -> void:
	DisplayServer.clipboard_set($CodePanel/Code.text)
	
	UiManager.message_bubble.show_message($Button, "Copiado.")
