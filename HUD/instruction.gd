extends Control


func show_massage(messages: Array) -> void:
	var index := 0
	
	await get_tree().create_timer(0.4).timeout
	
	if messages:
		while true:
			show_text_letter_by_letter(messages[index])
			
			await get_tree().create_timer(8.0).timeout
			
			index = (index + 1) % messages.size()


func show_text_letter_by_letter(message: String) -> void:
	$Bubble/Label.text = ""
	
	$Panel/AnimatedSprite2D.play("talk")
	
	for character in message:
		$Bubble/Label.text += character
		AudioManager.play_sound(Audio.MESSAGE)
		await get_tree().create_timer(0.05).timeout
	
	$Panel/AnimatedSprite2D.play("idle")
