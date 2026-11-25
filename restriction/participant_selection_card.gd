@tool
extends Control

@export var unselected_texture: Texture2D:
	set(value):
		unselected_texture = value
		
		if has_node("Background"):
			$Background.texture = value

@export var selected_texture: Texture2D

const DRAG_THRESHOLD := 10.0

var selected := false
var restriction_selection: CanvasLayer

var touching := false
var touch_moved := false
var touch_distance := 0.0


func select_participant() -> void:
	if restriction_selection:
		if not restriction_selection.can_select_restriction(self):
			return
	
	AudioManager.play_sound(Audio.CONFIRM)
	
	selected = not selected
	$Icon.visible = selected
	
	if selected:
		$Background.texture = selected_texture
		$Name.position.y += 2
	else:
		$Background.texture = unselected_texture
		$Name.position.y -= 2


func set_selected():
	selected = true
	$Icon.visible = true
	$Background.texture = selected_texture
	$Name.position.y += 2


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			touching = true
			touch_moved = false
			touch_distance = 0.0
		elif touching:
			touching = false
			
			if not touch_moved:
				select_participant()
	
	elif event is InputEventScreenDrag and touching:
		touch_distance += event.relative.length()
		
		if touch_distance > DRAG_THRESHOLD:
			touch_moved = true
	
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				touching = true
				touch_moved = false
				touch_distance = 0.0
			elif touching:
				touching = false
				
				if not touch_moved:
					select_participant()
	
	elif event is InputEventMouseMotion and touching:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			touch_distance += event.relative.length()
			
			if touch_distance > DRAG_THRESHOLD:
				touch_moved = true
