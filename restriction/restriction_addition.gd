extends Control

@onready var players_container = $CenterContainer/Control/Panel/PlayersArea/ScrollContainer/VBoxContainer

var one_cicle := false


const MESSAGES = [
	"Quem não pode tirar quem?",
	"Clique no + para adicionar."]


func _ready() -> void:
	load_players()
	update_players_number()
	$CenterContainer/Control/Instruction.show_massage(MESSAGES)


func load_players():
	for player in PlayerManager.players:
		add_player(player)


func add_player(player_name) -> void:
	var player = preload(Scene.PARTICIPANT_RESTRICTION_CARD).instantiate()
	
	player.get_node("Name").text = player_name
	
	players_container.add_child(player)


func update_players_number() -> void:
	var players = players_container.get_children()
	
	for i in players.size():
		players[i].set_number(i + 1)
	
	$CenterContainer/Control/Panel/PlayersNumber/Value.text = str(players.size())


func draw_names() -> Dictionary:
	var players: Array[String] = PlayerManager.players.duplicate()
	players.shuffle()
	
	# Ciclo único
	var path: Array[String] = [players[0]]
	var remaining: Array[String] = players.duplicate()
	remaining.erase(players[0])
	
	if find_cycle(path, remaining):
		one_cicle = true
		return create_draw_result(path)
	
	# Sem ciclo único
	players.shuffle()
	
	var result: Dictionary = {}
	var available: Array[String] = players.duplicate()
	
	if assign_players(players, available, result):
		one_cicle = false
		return sort_result(result)
	
	return {}


func find_cycle(path: Array[String], remaining: Array[String]):
	if remaining.is_empty():
		return not is_restricted(path[-1], path[0])
	
	var current_player = path[-1]
	var candidates: Array[String] = remaining.duplicate()
	candidates.shuffle()
	
	for candidate in candidates:
		if is_restricted(current_player, candidate):
			continue
		
		path.append(candidate)
		remaining.erase(candidate)
		
		if find_cycle(path, remaining):
			return sort_result(create_draw_result(path))
		
		path.pop_back()
		remaining.append(candidate)
	
	return false


func assign_players(
		players: Array[String],
		available: Array[String],
		result: Dictionary
	) -> bool:
	if result.size() == players.size():
		return true
	
	var player = ""
	
	for candidate in players:
		if not result.has(candidate):
			player = candidate
			break
	
	var candidates = available.duplicate()
	candidates.shuffle()
	
	for candidate in candidates:
		if candidate == player or is_restricted(player, candidate):
			continue
		
		result[player] = candidate
		available.erase(candidate)
		
		if assign_players(players, available, result):
			return true
		
		result.erase(player)
		available.append(candidate)
	
	return false


func is_restricted(player: String, target: String) -> bool:
	return target in PlayerManager.restrictions.get(player, [])


func create_draw_result(path: Array[String]) -> Dictionary:
	var result: Dictionary = {}
	
	for i in path.size():
		result[path[i]] = path[(i + 1) % path.size()]
	
	return sort_result(result)


func sort_result(result: Dictionary) -> Dictionary:
	var sorted_result: Dictionary = {}
	
	for player in PlayerManager.players:
		sorted_result[player] = result[player]
	
	return sorted_result


func _on_return_button_pressed() -> void:
	if PlayerManager.restrictions:
		UiManager.show_confirmation(
			"As restrições serão perdidas. Deseja voltar à tela anterior?",
			func():
				Transition.change_screen(load(Scene.PARTICIPANT_ADDITION))
		)
	else:
		Transition.change_screen(load(Scene.PARTICIPANT_ADDITION))


func _on_next_button_pressed() -> void:
	PlayerManager.sort = draw_names().duplicate()
	
	if PlayerManager.sort:
		if one_cicle:
			Transition.change_screen(load(Scene.CODE_DISTRIBUTION))
		else:
			UiManager.show_confirmation(
				"Não foi possível encontrar um único ciclo. Continuar mesmo assim?",
				func():
					Transition.change_screen(load(Scene.CODE_DISTRIBUTION))
			)
	else:
		UiManager.message_bubble.show_message($CenterContainer/Control/Panel/PlayersNumber, "Não foi possível sortear com as restrições atuais.")
