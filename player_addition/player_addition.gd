extends Control

@onready var players_container = $CenterContainer/Control/Panel/PlayersArea/ScrollContainer/VBoxContainer

const MESSAGES = [
	"Quem vai participar?",
	"O limite é de 15 caracteres.",
	"O X remove um participante."]


func _ready() -> void:
	if PlayerManager.players:
		for player in PlayerManager.players:
			add_player(player)
	else:
		add_player()
	
	PlayerManager.restrictions.clear()
	
	$CenterContainer/Control/Instruction.show_massage(MESSAGES)


func add_player(player_name = "") -> void:
	var player = preload(Scene.PLAYER_CARD).instantiate()
	
	player.deleted.connect(_on_player_deleted)
	player.enter_pressed.connect(add_player)
	
	players_container.add_child(player)
	
	update_players_number()
	
	await get_tree().process_frame
	
	player.get_node("Name").text = player_name
	player.focus_name()
	$CenterContainer/Control/Panel/PlayersArea/ScrollContainer.ensure_control_visible(player)


func update_players_number() -> void:
	var players = players_container.get_children()
	
	for i in players.size():
		players[i].set_number(i + 1)
	
	$CenterContainer/Control/Panel/PlayersNumber/Value.text = str(players.size())


func get_players_name() -> bool:
	var names: Array[String] = []
	var players = players_container.get_children()
	
	for player in players:
		var name_field: LineEdit = player.get_node("Name")
		var player_name: String = name_field.text.strip_edges()
		
		if player_name.is_empty() or names.has(player_name):
			name_field.grab_focus()
			name_field.select_all()
			$CenterContainer/Control/Panel/PlayersArea/ScrollContainer.ensure_control_visible(name_field)
			return false
		
		names.append(player_name)
	
	PlayerManager.players = names
	return true


func _on_add_button_pressed() -> void:
	add_player()


func _on_player_deleted() -> void:
	await get_tree().process_frame
	update_players_number()


func _on_next_button_pressed() -> void:
	if get_players_name():
		Transition.change_screen(load(Scene.RESTRICTION_ADDITION))


func _on_return_button_pressed() -> void:
	Transition.change_screen(load(Scene.START_MENU))
