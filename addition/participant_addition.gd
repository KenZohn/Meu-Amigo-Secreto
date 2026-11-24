extends Control

@onready var participants_container = $CenterContainer/Control/Panel/ParticipantsArea/ScrollContainer/VBoxContainer

const MESSAGES = [
	"Quem vai participar?",
	"O limite é de 15 caracteres.",
	"O X remove um participante."]


func _ready() -> void:
	load_participants()
	
	ParticipantManager.restrictions.clear()
	
	$CenterContainer/Control/Instruction.show_massage(MESSAGES)


func add_participant(participant_name = "") -> void:
	var participant = preload(Scene.PARTICIPANT_ADDITION_CARD).instantiate()
	var name_field = participant.get_node("Name")
	
	participant.deleted.connect(_on_participant_deleted)
	participant.enter_pressed.connect(add_participant)
	
	name_field.text_changed.connect(_on_name_text_changed.bind(name_field))
	
	participants_container.add_child(participant)
	
	name_field.text = participant_name
	name_field.grab_focus()
	$CenterContainer/Control/Panel/ParticipantsArea/ScrollContainer.ensure_control_visible(name_field)
	
	update_participants_number()
	#await get_tree().process_frame
	
	#name_field.text = participant_name
	
	#focus_control(name_field)


func update_participants_number() -> void:
	var participants = participants_container.get_children()
	
	for i in participants.size():
		participants[i].set_number(i + 1)
	
	$CenterContainer/Control/Panel/ParticipantsNumber/Value.text = str(participants.size())


func load_participants():
	if ParticipantManager.participants:
		for participant in ParticipantManager.participants:
			add_participant(participant)
		
		await get_tree().process_frame
		var focus_owner = get_viewport().gui_get_focus_owner()
		
		if focus_owner:
			focus_owner.release_focus()
	else:
		add_participant()


func get_participants_name() -> bool:
	var names: Array[String] = []
	var participants = participants_container.get_children()
	
	for participant in participants:
		var name_field = participant.get_node("Name")
		var participant_name = name_field.text.strip_edges()
		
		if participant_name.is_empty() or names.has(participant_name):
			await focus_control(name_field)
			
			if participant_name.is_empty():
				UiManager.message_bubble.show_message(name_field, "Insira um nome.")
			elif names.has(participant_name):
				UiManager.message_bubble.show_message(name_field, "Nome duplicado.")
			
			return false
		
		names.append(participant_name)
	
	if participants.size() < 3:
		UiManager.message_bubble.show_message($CenterContainer/Control/Panel/AddButton, "Mínimo de 3 participantes.")
		return false
	
	ParticipantManager.participants = names
	return true


func focus_control(field):
	field.grab_focus()
	
	$CenterContainer/Control/Panel/ParticipantsArea/ScrollContainer.ensure_control_visible(field)
	await get_tree().process_frame


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
	add_participant()


func _on_participant_deleted() -> void:
	await get_tree().process_frame
	
	update_participants_number()


func _on_next_button_pressed() -> void:
	if await get_participants_name():
		Transition.change_screen(load(Scene.RESTRICTION_ADDITION))


func _on_return_button_pressed() -> void:
	Transition.change_screen(load(Scene.START_MENU))
