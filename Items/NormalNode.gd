extends "res://Items/ConnectionNode.gd"

var isConnected = false

func toggleConnection(toggle):
	isConnected = toggle
	if isConnected == true:
		$AnimatedSprite.play("boot")
		$BlipSound.play()
	else:
		$AnimatedSprite.play("deactivating")
		$Shutdown.play()

func _on_ConnectionNode_body_entered(body):
	get_tree().call_group("GameController", "addConnection", self, ConnectionTypes.NORMAL)

func _on_AnimatedSprite_animation_finished() -> void:
	if $AnimatedSprite.animation == "boot":
		$AnimatedSprite.play("energized")
	elif $AnimatedSprite.animation == "deactivating":
		$AnimatedSprite.play("deactivated")
