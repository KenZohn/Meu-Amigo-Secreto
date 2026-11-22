extends Control


const MESSAGES = [
	"Copie e envie os códigos.",
	"O botão ao lado copia o código.",
	"Depois, envie a cada participante."]

func _ready() -> void:
	$CenterContainer/Control/Panel/PlayersArea/ScrollContainer.get_v_scroll_bar().value_changed.connect(_on_scroll_changed)
	
	show_code_card()
	
	$CenterContainer/Control/Instruction.show_massage(MESSAGES)


func base62_encode(value: int, length: int) -> String:
	var result := ""
	
	for i in length:
		result = Constants.BASE62_ALPHABET[value % 62] + result
		value /= 62
	
	return result


func generate_code(player_name: String, seconds: int) -> String:
	var original_length := player_name.length()
	
	# Preenchimento até 15 caracteres
	while player_name.length() < 15:
		var i := player_name.length()
		var index := (seconds + i * 13 + player_name.to_utf8_buffer()[0]) % Constants.ALPHABET.length()
		player_name += Constants.ALPHABET[index]
	
	# Conversão do horário e comprimento
	var time_code := base62_encode(seconds, 3)
	var length_code := base62_encode(original_length, 2)
	
	# Intercalação HCHCH
	var metadata := ""
	metadata += time_code[0] + length_code[0]
	metadata += time_code[1] + length_code[1]
	metadata += time_code[2]
	
	# Ofuscação dos 15 caracteres
	var encrypted := ""
	
	for i in 15:
		var index := Constants.ALPHABET.find(player_name[i])
		var key := (seconds + i) % Constants.ALPHABET.length()
		encrypted += Constants.ALPHABET[(index + key) % Constants.ALPHABET.length()]
	
	return encrypted + metadata


func show_code_card() -> void:
	var current_time := Time.get_time_dict_from_system()
	
	var seconds: int = current_time.hour * 3600 \
		+ current_time.minute * 60 \
		+ current_time.second
	
	var number := 1
	
	for player in PlayerManager.sort:
		var crypted = generate_code(PlayerManager.sort[player], seconds)
		
		var code_card = preload(Scene.CODE_CARD).instantiate()
		
		code_card.get_node("Number").text = str(number) + "."
		code_card.get_node("Name").text = player
		code_card.get_node("CodePanel/Code").text = crypted
		
		$CenterContainer/Control/Panel/PlayersArea/ScrollContainer/VBoxContainer.add_child(code_card)
		
		number += 1


func _on_scroll_changed(_value: float) -> void:
	UiManager.message_bubble.hide_message()


func _on_return_button_pressed() -> void:
	var confirmation_dialog = preload(Scene.CONFIRMATION_DIALOG).instantiate()
			
	confirmation_dialog.show_dialog("Os códigos sorteados serão perdidos. Deseja voltar à tela anterior?")
	
	confirmation_dialog.confirm.connect(
		func():
			Transition.change_screen(load(Scene.RESTRICTION_ADDITION))
	)
	
	add_child(confirmation_dialog)


func _on_end_button_pressed() -> void:
	var confirmation_dialog = preload(Scene.CONFIRMATION_DIALOG).instantiate()
		
	confirmation_dialog.show_dialog("Deseja finalizar e voltar à tela inicial?")
	
	confirmation_dialog.confirm.connect(
		func():
			Transition.change_screen(load(Scene.START_MENU))
	)
	
	add_child(confirmation_dialog)
