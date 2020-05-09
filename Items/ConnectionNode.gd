extends Area2D

const ConnectionTypes = preload("res://Globals/ConnectionTypes.gd").ConnectionTypes

func _on_ConnectionNode_body_entered(body):
	get_tree().call_group("GameController", "addConnection", self, ConnectionTypes.NORMAL)
