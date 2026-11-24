extends CanvasLayer

@onready var selection_container = $CenterContainer/Control/Content/Panel/PlayersArea/ScrollContainer/SelectionContainer

const MESSAGES = [
	"Quem essa pessoa não pode tirar?",
	"Clique no nome para selecionar."]

var player_number: String
var player_name: String
var selected_players: Array[String] = []


func _ready() -> void:
	get_tree().paused = true
	
	$AnimationPlayer.play("pop_in")
	
	load_players()
	
	$CenterContainer/Control/Content/Panel/Control/Number.text = player_number
	$CenterContainer/Control/Content/Panel/Control/Name.text = player_name
	
	$CenterContainer/Control/Content/Instruction.show_massage(MESSAGES)


func load_players() -> void:
	var player_selection_card = preload(Scene.PARTICIPANT_SELECTION_CARD)
	
	for player in PlayerManager.players:
		if player == player_name:
			continue
		
		var player_selection = player_selection_card.instantiate()
		var player_selection_name = player_selection.get_node("Name")
		
		player_selection_name.text = player
		player_selection.restriction_selection = self
		
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


func can_select_restriction(player_selection) -> bool:
	if player_selection.selected:
		UiManager.message_bubble.hide_message()
		return true
	
	var selected_count = 0
	
	for player in selection_container.get_children():
		if player.selected:
			selected_count += 1
	
	if selected_count == selection_container.get_child_count() - 1:
		UiManager.message_bubble.show_message(player_selection, "Não é possível restringir todos.")
		return false
	
	UiManager.message_bubble.hide_message()
	return true


func _on_confirm_button_pressed() -> void:
	get_selected_players()
	
	get_parent().update_restricted()
	
	$AnimationPlayer.play("pop_out")
	await $AnimationPlayer.animation_finished
	
	get_tree().paused = false
	
	queue_free()
