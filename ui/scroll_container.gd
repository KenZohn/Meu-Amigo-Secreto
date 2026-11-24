extends ScrollContainer


func _ready() -> void:
	get_v_scroll_bar().value_changed.connect(_on_scroll_changed)


func _on_scroll_changed(_value: float) -> void:
	UiManager.message_bubble.hide_message()
