extends "res://Levels/LevelTemplate.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	var rotation = $YSort/Nodes.rotation_degrees
	var diff
	print(rotation)
	
	for child in $YSort/Nodes.get_children():
		child.global_rotation = 0
	
	for child in $YSort/Blockers.get_children():
		child.global_rotation = 0
