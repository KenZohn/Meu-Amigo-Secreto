extends Control


const MESSAGES = [
	"Copie e envie os códigos.",
	"O botão ao lado copia o código.",
	"Depois, envie a cada participante."]

func _ready() -> void:
	show_code_card()
	
	$CenterContainer/Control/Instruction.show_massage(MESSAGES)


func base62_encode(value: int, length: int) -> String:
	var result := ""
	
	for i in length:
		result = Constants.BASE62_ALPHABET[value % 62] + result
		value /= 62
	
	return result


func generate_code(participant_name: String, seconds: int) -> String:
	var name_length := participant_name.length()
	
	while participant_name.length() < 15:
		var i := participant_name.length()
		var index := (seconds + i * 13 + participant_name.to_utf8_buffer()[0]) % Constants.ALPHABET.length()
		participant_name += Constants.ALPHABET[index]
	
	var time_code := base62_encode(seconds, 3)
	var encrypted_length := (name_length + seconds) % 3844
	var length_code := base62_encode(encrypted_length, 2)
	
	var metadata := time_code[0] + length_code[0] + time_code[1] + length_code[1] + time_code[2]
	
	var encrypted := ""
	
	for i in 15:
		var index := Constants.ALPHABET.find(participant_name[i])
		var key := (seconds + i) % Constants.ALPHABET.length()
		encrypted += Constants.ALPHABET[(index + key) % Constants.ALPHABET.length()]
	
	return encrypted + metadata


func show_code_card() -> void:
	var current_time := Time.get_time_dict_from_system()
	
	var seconds: int = current_time.hour * 3600 + current_time.minute * 60 + current_time.second
	
	var number := 1
	
	for participant in ParticipantManager.sort:
		var crypted = generate_code(ParticipantManager.sort[participant], seconds)
		
		var code_card = preload(Scene.CODE_CARD).instantiate()
		
		code_card.get_node("Number").text = str(number) + "."
		code_card.get_node("Name").text = participant
		code_card.get_node("CodePanel/Code").text = crypted
		
		$CenterContainer/Control/Panel/ParticipantsArea/ScrollContainer/VBoxContainer.add_child(code_card)
		
		number += 1


func _on_return_button_pressed() -> void:
	UiManager.show_confirmation(
		"Os códigos sorteados serão perdidos. Deseja voltar à tela anterior?",
		func():
			Transition.change_screen(load(Scene.RESTRICTION_ADDITION))
	)


func _on_end_button_pressed() -> void:
	UiManager.show_confirmation(
		"Deseja finalizar e voltar à tela inicial?",
		func():
			Transition.change_screen(load(Scene.START_MENU))
	)
