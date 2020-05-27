extends Node2D

onready var point1 = $Point1
onready var point2 = $Point2

var test = Vector2()

var rng = RandomNumberGenerator.new()

func _ready():
	pass

func generatePath(line):
	line.clear_points()

	var distance = rng.randf_range(20, 40)
	var dir = (point2.global_position - point1.global_position).normalized()
	
	var ortognal = dir.rotated(PI / 2)
	
	var totalDistance = $Point1.global_position.distance_to($Point2.global_position)
	var steps = totalDistance / distance
	
	var temp
	var ortDir = 1
	
	line.width = rng.randf_range(1, 4)
	line.add_point(Vector2(0, 0))
	
	for it in range(2, steps):
		temp = dir * distance * it
		ortDir = rng.randi_range(-1, 1)
		line.add_point( temp + (ortognal * rng.randf_range(1, 15) * ortDir) )

	line.add_point(point2.global_position - point1.global_position)


func _on_Timer_timeout():
	generatePath($Point1/Node/Line2D)
	generatePath($Point1/Node/Line2D2)
	generatePath($Point1/Node/Line2D3)
