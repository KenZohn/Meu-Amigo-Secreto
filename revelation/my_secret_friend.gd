extends CanvasLayer

var secret_friend :String


func _ready() -> void:
	$CenterContainer/SecretFriendName.text = secret_friend
	
	await get_tree().create_timer(1.0).timeout
	
	$AnimationPlayer.play("fade_in")
	
	await get_tree().create_timer(5.0).timeout
	
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	
	Transition.change_screen(load(Scene.START_MENU), "fade")
