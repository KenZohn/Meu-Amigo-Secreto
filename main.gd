extends Control


func _ready() -> void:
	$MessageLayer.add_child(UiManager.message_bubble)
	$MessageLayer.add_child(UiManager.confirmation_dialog)
	
	Transition.change_screen(load(Scene.START_MENU))
