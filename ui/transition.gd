extends CanvasLayer

var current_screen: Control


func change_screen(scene: PackedScene, animation: String = "pop_up") -> void:
	get_tree().current_scene.message_bubble.hide_message()
	
	$AnimationPlayer.play(animation + "_out" )
	
	await $AnimationPlayer.animation_finished
	
	var new_screen = scene.instantiate()
	
	if current_screen:
		current_screen.queue_free()
	
	$CenterContainer/ScreenContainer.add_child(new_screen)
	current_screen = new_screen
	
	$AnimationPlayer.play(animation + "_in")
	await $AnimationPlayer.animation_finished


func fade_out():
	$Overlay.visible = true
	
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
