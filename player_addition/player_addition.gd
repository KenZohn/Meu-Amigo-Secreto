extends Control

@onready var players_container = $CenterContainer/Control/Panel/PlayersArea/ScrollContainer/VBoxContainer
@onready var scroll_container = $CenterContainer/Control/Panel/PlayersArea/ScrollContainer

const MESSAGES = [
	"Quem vai participar?",
	"O limite é de 15 caracteres.",
	"O X remove um participante."]

var adjusting_scroll := false


func _ready() -> void:
	scroll_container.get_v_scroll_bar().value_changed.connect(_on_scroll_changed)
	
	load_players()
	
	PlayerManager.restrictions.clear()
	
	$CenterContainer/Control/Instruction.show_massage(MESSAGES)


func add_player(player_name = "") -> void:
	var player = preload(Scene.PLAYER_CARD).instantiate()
	var name_field = player.get_node("Name")
	
	player.deleted.connect(_on_player_deleted)
	player.enter_pressed.connect(add_player)
	
	name_field.text_changed.connect(_on_name_text_changed.bind(name_field))
	
	players_container.add_child(player)
	
	update_players_number()
	await get_tree().process_frame
	
	name_field.text = player_name
	
	await focus_control(name_field)


func update_players_number() -> void:
	var players = players_container.get_children()
	
	for i in players.size():
		players[i].set_number(i + 1)
	
	$CenterContainer/Control/Panel/PlayersNumber/Value.text = str(players.size())


func load_players():
	if PlayerManager.players:
		for player in PlayerManager.players:
			add_player(player)
	else:
		add_player()


func get_players_name() -> bool:
	var names: Array[String] = []
	var players = players_container.get_children()
	
	for player in players:
		var name_field = player.get_node("Name")
		var player_name = name_field.text.strip_edges()
		
		if player_name.is_empty() or names.has(player_name):
			await focus_control(name_field)
			
			if player_name.is_empty():
				UiManager.message_bubble.show_message(name_field, "Insira um nome.")
			elif names.has(player_name):
				UiManager.message_bubble.show_message(name_field, "Nome duplicado.")
			
			return false
		
		names.append(player_name)
	
	if players.size() < 3:
		UiManager.message_bubble.show_message($CenterContainer/Control/Panel/AddButton, "Mínimo de 3 participantes.")
		return false
	
	PlayerManager.players = names
	return true


func focus_control(field):
	adjusting_scroll = true
	
	field.grab_focus()
	
	scroll_container.ensure_control_visible(field)
	await get_tree().process_frame
	
	adjusting_scroll = false


func _on_scroll_changed(_value: float) -> void:
	if not adjusting_scroll:
		UiManager.message_bubble.hide_message()


func _on_name_text_changed(new_text: String, name_field: LineEdit) -> void:
	var filtered_text := ""
	var invalid_character := false
	
	for character in new_text:
		if Constants.ALPHABET.contains(character):
			filtered_text += character
		else:
			invalid_character = true
			break
	
	var exceeded_limit := filtered_text.length() > Constants.MAX_NAME_LENGTH
	
	filtered_text = filtered_text.left(Constants.MAX_NAME_LENGTH)
	
	if new_text != filtered_text:
		name_field.text = filtered_text
		name_field.caret_column = filtered_text.length()
	
	if invalid_character or exceeded_limit:
		await focus_control(name_field)
		
		if invalid_character:
			UiManager.message_bubble.show_message(name_field, "Caractere inválido.")
		else:
			UiManager.message_bubble.show_message(name_field, "Limite de 15 caracteres.")


func _on_add_button_pressed() -> void:
	add_player()


func _on_player_deleted() -> void:
	await get_tree().process_frame
	
	update_players_number()


func _on_next_button_pressed() -> void:
	if await get_players_name():
		Transition.change_screen(load(Scene.RESTRICTION_ADDITION))


func _on_return_button_pressed() -> void:
	Transition.change_screen(load(Scene.START_MENU))
