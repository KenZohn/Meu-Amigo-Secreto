extends CanvasLayer

signal confirm


func show_dialog(text):
	get_tree().paused = true
	
	show()
	$AnimationPlayer.play("pop_in")
	$CenterContainer/Control/Content/Panel/Label.text = text


func finish_dialog():
	$AnimationPlayer.play("pop_out")
	await $AnimationPlayer.animation_finished
	
	get_tree().paused = false
	hide()


func _on_confirm_button_pressed() -> void:
	await finish_dialog()
	
	confirm.emit()


func _on_cancel_button_pressed() -> void:
	await finish_dialog()
