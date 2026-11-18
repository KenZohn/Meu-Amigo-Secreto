extends Control

var selected := false
var restriction_selection: CanvasLayer

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if restriction_selection:
			if not restriction_selection.can_select_restriction(self):
				return
			
		selected = not selected
		$Icon.visible = selected
