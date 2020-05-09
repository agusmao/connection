extends Area2D

const ConnectionTypes = preload("res://Globals/ConnectionTypes.gd").ConnectionTypes

export (ConnectionTypes) var type = ConnectionTypes.NORMAL

func _on_ConnectionNode_body_entered(body):
	get_tree().call_group("GameController", "addConnection", self, type)
