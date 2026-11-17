extends Control


func _ready() -> void:
	$CenterContainer/Control/CodePanel/Code.grab_focus()


func base62_decode(value: String) -> int:
	var result := 0
	
	for character in value:
		result = result * 62 + Constants.BASE62_ALPHABET.find(character)
	
	return result


func reveal_name(code: String) -> String:
	var encrypted := code.substr(0, 15)
	var metadata := code.substr(15, 5)
	
	# Recuperação do horário
	var time_code := metadata[0] + metadata[2] + metadata[4]
	var seconds := base62_decode(time_code)
	
	# Recuperação do comprimento
	var length_code := metadata[1] + metadata[3]
	var original_length := base62_decode(length_code)
	
	# Desfaz a substituição
	var player_name := ""
	
	for i in 15:
		var index := Constants.ALPHABET.find(encrypted[i])
		var key := (seconds + i) % Constants.ALPHABET.length()
		player_name += Constants.ALPHABET[(index - key + Constants.ALPHABET.length()) % Constants.ALPHABET.length()]
	
	return player_name.substr(0, original_length)


func _on_reveal_button_pressed() -> void:
	var code = $CenterContainer/Control/CodePanel/Code.text
	
	if code.length() == 20:
		await Transition.fade_out()
		
		var my_secret_friend = preload(Scene.MY_SECRET_FRIEND).instantiate()
		
		my_secret_friend.secret_friend = reveal_name(code)
		
		add_child(my_secret_friend)
	else:
		print("Código inválido")
		
		$CenterContainer/Control/CodePanel/Code.grab_focus()


func _on_return_button_pressed() -> void:
	Transition.change_screen(load(Scene.START_MENU))
