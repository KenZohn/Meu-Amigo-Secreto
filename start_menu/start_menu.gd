extends Control


func _ready() -> void:
	var cursor_image = load("res://asset/Sprout Lands - UI Pack - Basic pack/Sprite sheets/Mouse sprites/Triangle Mouse icon 1.png") as Texture2D
	var image = cursor_image.get_image()
	
	image.resize(
		image.get_width() * 2,
		image.get_height() * 2,
		Image.INTERPOLATE_NEAREST
	)
	
	var cursor_texture = ImageTexture.create_from_image(image)
	
	Input.set_custom_mouse_cursor(
		cursor_texture,
		Input.CURSOR_ARROW,
		Vector2(3, 3)
	)


func _on_new_game_button_pressed() -> void:
	Transition.change_screen(load(Scene.PLAYER_ADDITION))


func _on_reveal_button_pressed() -> void:
	Transition.change_screen(load(Scene.REVELATION))
