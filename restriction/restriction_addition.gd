extends Control

@onready var participants_container = $CenterContainer/Control/Panel/ParticipantsArea/ScrollContainer/VBoxContainer

var one_cicle := false


const MESSAGES = [
	"Quem não pode tirar quem?",
	"Clique no + para adicionar."]


func _ready() -> void:
	load_participants()
	update_participants_number()
	$CenterContainer/Control/Instruction.show_massage(MESSAGES)


func load_participants():
	for participant in ParticipantManager.participants:
		add_participant(participant)


func add_participant(participant_name) -> void:
	var participant = preload(Scene.PARTICIPANT_RESTRICTION_CARD).instantiate()
	
	participant.get_node("Name").text = participant_name
	
	participants_container.add_child(participant)


func update_participants_number() -> void:
	var participants = participants_container.get_children()
	
	for i in participants.size():
		participants[i].set_number(i + 1)
	
	$CenterContainer/Control/Panel/ParticipantsNumber/Value.text = str(participants.size())


func draw_names() -> Dictionary:
	var participants: Array[String] = ParticipantManager.participants.duplicate()
	participants.shuffle()
	
	# Ciclo único
	var path: Array[String] = [participants[0]]
	var remaining: Array[String] = participants.duplicate()
	remaining.erase(participants[0])
	
	if find_cycle(path, remaining):
		one_cicle = true
		return create_draw_result(path)
	
	# Sem ciclo único
	participants.shuffle()
	
	var result: Dictionary = {}
	var available: Array[String] = participants.duplicate()
	
	if assign_participants(participants, available, result):
		one_cicle = false
		return sort_result(result)
	
	return {}


func find_cycle(path: Array[String], remaining: Array[String]):
	if remaining.is_empty():
		return not is_restricted(path[-1], path[0])
	
	var current_participant = path[-1]
	var candidates: Array[String] = remaining.duplicate()
	candidates.shuffle()
	
	for candidate in candidates:
		if is_restricted(current_participant, candidate):
			continue
		
		path.append(candidate)
		remaining.erase(candidate)
		
		if find_cycle(path, remaining):
			return sort_result(create_draw_result(path))
		
		path.pop_back()
		remaining.append(candidate)
	
	return false


func assign_participants(
		participants: Array[String],
		available: Array[String],
		result: Dictionary
	) -> bool:
	if result.size() == participants.size():
		return true
	
	var participant = ""
	
	for candidate in participants:
		if not result.has(candidate):
			participant = candidate
			break
	
	var candidates = available.duplicate()
	candidates.shuffle()
	
	for candidate in candidates:
		if candidate == participant or is_restricted(participant, candidate):
			continue
		
		result[participant] = candidate
		available.erase(candidate)
		
		if assign_participants(participants, available, result):
			return true
		
		result.erase(participant)
		available.append(candidate)
	
	return false


func is_restricted(participant: String, target: String) -> bool:
	return target in ParticipantManager.restrictions.get(participant, [])


func create_draw_result(path: Array[String]) -> Dictionary:
	var result: Dictionary = {}
	
	for i in path.size():
		result[path[i]] = path[(i + 1) % path.size()]
	
	return sort_result(result)


func sort_result(result: Dictionary) -> Dictionary:
	var sorted_result: Dictionary = {}
	
	for participant in ParticipantManager.participants:
		sorted_result[participant] = result[participant]
	
	return sorted_result


func _on_return_button_pressed() -> void:
	if ParticipantManager.restrictions:
		UiManager.show_confirmation(
			"As restrições serão perdidas. Deseja voltar à tela anterior?",
			func():
				Transition.change_screen(load(Scene.PARTICIPANT_ADDITION))
		)
	else:
		Transition.change_screen(load(Scene.PARTICIPANT_ADDITION))


func _on_next_button_pressed() -> void:
	ParticipantManager.sort = draw_names().duplicate()
	
	if ParticipantManager.sort:
		if one_cicle:
			Transition.change_screen(load(Scene.CODE_DISTRIBUTION))
		else:
			UiManager.show_confirmation(
				"Não foi possível encontrar um único ciclo. Continuar mesmo assim?",
				func():
					Transition.change_screen(load(Scene.CODE_DISTRIBUTION))
			)
	else:
		UiManager.message_bubble.show_message($CenterContainer/Control/Panel/ParticipantsNumber, "Não foi possível sortear com as restrições atuais.")
