extends Node

var message_bubble = preload(Scene.MESSAGE_BUBBLE).instantiate()
var confirmation_dialog = preload(Scene.CONFIRMATION_DIALOG).instantiate()

func show_confirmation(message: String, callback: Callable) -> void:
	confirmation_dialog.confirm.connect(callback, CONNECT_ONE_SHOT)
	confirmation_dialog.show_dialog(message)
