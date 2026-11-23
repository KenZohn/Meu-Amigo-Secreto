extends CanvasLayer

signal confirm


func _ready() -> void:
	get_tree().paused = true
	
	$AnimationPlayer.play("pop_in")


func show_dialog(text):
	$CenterContainer/Control/Content/Panel/Label.text = text


func finish_dialog():
	$AnimationPlayer.play("pop_out")
	await $AnimationPlayer.animation_finished
	
	get_tree().paused = false


func _on_confirm_button_pressed() -> void:
	await finish_dialog()
	
	confirm.emit()


func _on_cancel_button_pressed() -> void:
	await finish_dialog()
	
	queue_free()
