extends CanvasLayer

@onready var selection_container = $CenterContainer/Control/Content/Panel/ParticipantsArea/ScrollContainer/SelectionContainer

const MESSAGES = [
	"Quem essa pessoa não pode tirar?",
	"Clique no nome para selecionar."]

var participant_number: String
var participant_name: String
var selected_participants: Array[String] = []


func _ready() -> void:
	get_tree().paused = true
	
	$AnimationPlayer.play("pop_in")
	
	load_participants()
	
	$CenterContainer/Control/Content/Panel/Control/Number.text = participant_number
	$CenterContainer/Control/Content/Panel/Control/Name.text = participant_name
	
	$CenterContainer/Control/Content/Instruction.show_massage(MESSAGES)


func load_participants() -> void:
	var participant_selection_card = preload(Scene.PARTICIPANT_SELECTION_CARD)
	
	for participant in ParticipantManager.participants:
		if participant == participant_name:
			continue
		
		var participant_selection = participant_selection_card.instantiate()
		var participant_selection_name = participant_selection.get_node("Name")
		
		participant_selection_name.text = participant
		participant_selection.restriction_selection = self
		
		if ParticipantManager.restrictions.has(participant_name):
			if participant_selection_name.text in ParticipantManager.restrictions[participant_name]:
				participant_selection.selected = true
				participant_selection.get_node("Icon").visible = true
		
		selection_container.add_child(participant_selection)


func get_selected_participants() -> void:
	selected_participants.clear()
	
	for participant in selection_container.get_children():
		if participant.selected:
			selected_participants.append(participant.get_node("Name").text)
	
	ParticipantManager.restrictions[participant_name] = selected_participants.duplicate()


func can_select_restriction(participant_selection) -> bool:
	if participant_selection.selected:
		UiManager.message_bubble.hide_message()
		return true
	
	var selected_count = 0
	
	for participant in selection_container.get_children():
		if participant.selected:
			selected_count += 1
	
	if selected_count == selection_container.get_child_count() - 1:
		UiManager.message_bubble.show_message(participant_selection, "Não é possível restringir todos.")
		return false
	
	UiManager.message_bubble.hide_message()
	return true


func _on_confirm_button_pressed() -> void:
	get_selected_participants()
	
	get_parent().update_restricted()
	
	$AnimationPlayer.play("pop_out")
	await $AnimationPlayer.animation_finished
	
	get_tree().paused = false
	
	queue_free()
