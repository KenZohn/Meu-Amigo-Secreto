extends PanelContainer


func show_message(target, message: String) -> void:
	scale = Vector2.ONE
	pivot_offset = size / 2
	
	$Margin/Label.text = message
	
	global_position = target.global_position
	global_position.y -= size.y + 4
	
	show()
	
	play_pop_up()
	
	$DisplayTimer.start(3.0)


func hide_message() -> void:
	$DisplayTimer.stop()
	play_pop_down()


func play_pop_up() -> void:
	pivot_offset = size / 2
	scale = Vector2.ZERO
	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.15)
	tween.tween_property(self, "scale", Vector2.ONE, 0.08)


func play_pop_down() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.15)
	await tween.finished
	hide()


func _on_display_timer_timeout() -> void:
	hide_message()
