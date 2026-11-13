extends CanvasLayer

var secret_friend :String


func _ready() -> void:
	$SecretFriendName.text = secret_friend
	
	await get_tree().create_timer(1.0).timeout
	
	$AnimationPlayer.play("fade_in")
