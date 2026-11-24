@tool
extends PanelContainer

var tween: Tween


func show_message(target, message: String, color: Color = Color("ff3b2cff")) -> void:
	scale = Vector2.ONE
	pivot_offset = size / 2
	
	$Margin/Label.text = message
	$Margin/Label.add_theme_color_override("font_outline_color", color)
	
	reset_size()
	
	global_position = target.global_position
	global_position.y -= size.y + 4
	
	show()
	
	play_pop_up()
	
	$DisplayTimer.start(3.0)


func hide_message() -> void:
	$DisplayTimer.stop()
	play_pop_down()


func play_pop_up() -> void:
	if tween and tween.is_running():
		tween.kill()
	
	pivot_offset = size / 2
	scale = Vector2.ZERO
	
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.15)
	tween.tween_property(self, "scale", Vector2.ONE, 0.08)


func play_pop_down() -> void:
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.15)
	tween.tween_callback(hide)


func _on_display_timer_timeout() -> void:
	hide_message()


func _on_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed) \
	or (event is InputEventScreenTouch and event.pressed):
		hide_message()
