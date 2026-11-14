@tool
extends Button

@export var button_text: String:
	set(value):
		button_text = value
		
		if has_node("Label"):
			$Label.text = value


func _ready() -> void:
	$Label.text = button_text


func _on_mouse_entered() -> void:
	$AnimationPlayer.play("focus")
	$Cursor.visible = true


func _on_mouse_exited() -> void:
	$AnimationPlayer.play("RESET")
	$Cursor.visible = false
