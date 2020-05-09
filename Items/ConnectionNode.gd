extends Area2D

func _on_ConnectionNode_body_entered(body):
	get_tree().call_group("GameController", "addConnection", self)
