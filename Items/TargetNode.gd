extends "res://Items/ConnectionNode.gd"

func _on_ConnectionNode_body_entered(body):
	get_tree().call_group("GameController", "addConnection", self, ConnectionTypes.GOAL)
	
func toggleConnection(toggle):
	$AudioStreamPlayer2D.play()
	$AnimatedSprite.play("on")
