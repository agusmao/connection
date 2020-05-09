extends "res://Items/ConnectionNode.gd"

var isConnected = false

func _on_ConnectionNode_body_entered(body):
	get_tree().call_group("GameController", "addConnection", self, ConnectionTypes.NORMAL)
	isConnected = !isConnected
	if isConnected == true:
		$AnimatedSprite.play("boot")
		$BlipSound.play()
	else:
		$AnimatedSprite.play("deactivating")
		$Shutdown.play()


func _on_AnimatedSprite_animation_finished() -> void:
	if $AnimatedSprite.animation == "boot":
		$AnimatedSprite.play("energized")
	elif $AnimatedSprite.animation == "deactivating":
		$AnimatedSprite.play("deactivated")
