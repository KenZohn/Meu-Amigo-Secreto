extends Control


func _ready() -> void:
	update_restricted()


func set_number(number: int) -> void:
	$Number.text = str(number) + "."


func update_size() -> void:
	var participant_height = $Background.size.y
	var restrictions_height = $RestrictedContainer.get_combined_minimum_size().y
	
	custom_minimum_size.y = participant_height + (restrictions_height + 4 if restrictions_height > 0 else 0)


func add_restricted(restricted_participant_name) -> void:
	var restricted_participant = preload(Scene.PARTICIPANT_RESTRICTED_CARD).instantiate()
	
	$RestrictedContainer.add_child(restricted_participant)
	
	restricted_participant.get_node("Name").text = restricted_participant_name


func update_restricted() -> void:
	for child in $RestrictedContainer.get_children():
		$RestrictedContainer.remove_child(child)
		child.queue_free()
	
	for participant in ParticipantManager.restrictions.keys():
		if participant == $Name.text:
			for restricted_participant in ParticipantManager.restrictions[participant]:
				add_restricted(restricted_participant)
	
	update_size()


func _on_button_pressed() -> void:
	var restriction_selection = preload(Scene.RESTRICTION_SELECTION).instantiate()
	
	restriction_selection.participant_name = $Name.text
	restriction_selection.participant_number = $Number.text
	
	add_child(restriction_selection)
