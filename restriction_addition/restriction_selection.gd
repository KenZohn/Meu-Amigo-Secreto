extends CanvasLayer

@onready var selection_container = $CenterContainer/Control/Panel/PlayersArea/ScrollContainer/SelectionContainer

const MESSAGES = [
	"Quem essa pessoa não pode tirar?",
	"Clique no nome para selecionar."]

var player_number: String
var player_name: String
var selected_players: Array[String] = []


func _ready() -> void:
	load_player_selection_card()
	
	$CenterContainer/Control/Panel/Control/Number.text = player_number
	$CenterContainer/Control/Panel/Control/Name.text = player_name
	
	$CenterContainer/Control/Instruction.show_massage(MESSAGES)


func load_player_selection_card() -> void:
	var player_selection_card = preload(Scene.PLAYER_SELECTION_CARD)
	
	for player in PlayerManager.players:
		if player == player_name:
			continue
		
		var player_selection = player_selection_card.instantiate()
		var player_selection_name = player_selection.get_node("Name")
		
		player_selection_name.text = player
		
		if PlayerManager.restrictions.has(player_name):
			if player_selection_name.text in PlayerManager.restrictions[player_name]:
				player_selection.selected = true
				player_selection.get_node("Icon").visible = true
		
		selection_container.add_child(player_selection)


func get_selected_players() -> void:
	selected_players.clear()
	
	for player in selection_container.get_children():
		if player.selected:
			selected_players.append(player.get_node("Name").text)
	
	PlayerManager.restrictions[player_name] = selected_players.duplicate()


func _on_confirm_button_pressed() -> void:
	get_selected_players()
	
	get_parent().update_restricted()
	
	queue_free()
