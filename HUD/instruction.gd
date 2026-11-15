extends Control

var writing_text := false


func show_massage(messages: Array) -> void:
	var index := 0
	
	await get_tree().create_timer(0.4).timeout
	
	if messages:
		while true:
			await show_text_letter_by_letter(messages[index])
			
			$Timer.start(6.0)
			await $Timer.timeout
			
			index = (index + 1) % messages.size()


func show_text_letter_by_letter(message: String) -> void:
	if writing_text:
		return
	
	writing_text = true
	
	$Bubble/Label.text = ""
	$Panel/AnimatedSprite2D.play("talk")
	
	for character in message:
		$Bubble/Label.text += character
		AudioManager.play_sound(Audio.MESSAGE)
		
		$Timer.start(0.05)
		await $Timer.timeout
		
	$Panel/AnimatedSprite2D.play("idle")
	writing_text = false
