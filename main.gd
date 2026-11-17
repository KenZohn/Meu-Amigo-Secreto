extends Control

const MESSAGE_BUBBLE = preload(Scene.MESSAGE_BUBBLE)

var message_bubble = MESSAGE_BUBBLE.instantiate()


func _ready() -> void:
	UiManager.message_bubble = message_bubble
	
	$MessageLayer.add_child(message_bubble)
	
	Transition.change_screen(load(Scene.START_MENU))
