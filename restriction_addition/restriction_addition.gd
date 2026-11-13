extends Control

@onready var players_container = $CenterContainer/Control/Panel/PlayersArea/ScrollContainer/VBoxContainer


func _ready() -> void:
	for player in PlayerManager.players:
		add_player(player)
	
	update_players_number()


func add_player(player_name) -> void:
	var player = preload(Scene.PLAYER_RESTRICTION_CARD).instantiate()
	
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
	
	# Primeira tentativa: ciclo único
	var path: Array[String] = [players[0]]
	var remaining: Array[String] = players.duplicate()
	remaining.erase(players[0])
	
	if find_cycle(path, remaining):
		return create_draw_result(path)
	
	# Segunda tentativa: apenas respeitar as restrições
	players.shuffle()
	
	var result: Dictionary = {}
	var available: Array[String] = players.duplicate()
	
	if assign_players(players, available, result):
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
	get_tree().change_scene_to_file(Scene.PLAYER_ADDITION)


func _on_next_button_pressed() -> void:
	PlayerManager.sort = draw_names().duplicate()
	
	get_tree().change_scene_to_file(Scene.CODE_DISTRIBUTION)
