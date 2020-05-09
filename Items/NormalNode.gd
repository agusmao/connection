extends "res://Items/ConnectionNode.gd"

var isConnected = false

func _on_ConnectionNode_body_entered(body):
	get_tree().call_group("GameController", "addConnection", self, ConnectionTypes.NORMAL)
	isConnected = !isConnected
	if isConnected == true:
		$AnimatedSprite.play("energized")
	else:
		$AnimatedSprite.play("deactivated")
