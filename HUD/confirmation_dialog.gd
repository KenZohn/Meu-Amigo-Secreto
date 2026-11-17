extends CanvasLayer


func _ready() -> void:
	$AnimationPlayer.play("pop_in")


func show_dialog(text):
	$CenterContainer/Control/Content/Panel/Label.text = text
