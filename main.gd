extends Control


func _ready() -> void:
	Transition.change_screen(load(Scene.START_MENU))
