extends Control


func _ready() -> void:
	update_restricted()


func set_number(number: int) -> void:
	$Number.text = str(number) + "."


func update_size() -> void:
	var player_height = $Background.size.y
	var restrictions_height = $RestrictedContainer.get_combined_minimum_size().y
	
	custom_minimum_size.y = player_height + (restrictions_height + 4 if restrictions_height > 0 else 0)


func add_restricted(restricted_player_name) -> void:
	var restricted_player = preload(Scene.PLAYER_RESTRICTED_CARD).instantiate()
	
	$RestrictedContainer.add_child(restricted_player)
	
	restricted_player.get_node("Name").text = restricted_player_name


func update_restricted() -> void:
	for child in $RestrictedContainer.get_children():
		$RestrictedContainer.remove_child(child)
		child.queue_free()
	
	for player in PlayerManager.restrictions.keys():
		if player == $Name.text:
			for restricted_player in PlayerManager.restrictions[player]:
				add_restricted(restricted_player)
	
	update_size()


func _on_button_pressed() -> void:
	get_tree().paused = true
	
	var restriction_selection = preload(Scene.RESTRICTION_SELECTION).instantiate()
	
	restriction_selection.player_name = $Name.text
	restriction_selection.player_number = $Number.text
	
	add_child(restriction_selection)
