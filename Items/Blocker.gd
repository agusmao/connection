extends KinematicBody2D

const MAX_SPEED = 300

export (int) var id
export (int) var connected_to
export (float) var wait_time

export var walk_speed = 0.3

var minimal_distance = 10

var positions = []

var nextPosition
var current_goal
var motion

var blocked

func _ready():
	
	for child in get_children():
		if child is Position2D:
			positions.append(global_position + child.position)
		
	
	if len(positions) > 0:
		current_goal = 0
		nextPosition = positions[current_goal]
	
	$Timer.wait_time = wait_time
	
	blocked = false

func _physics_process(delta):
	if len(positions) > 1 and not blocked:
		var distance = nextPosition.distance_to(global_position)
		print(distance)
		if distance < minimal_distance:
			blocked = true
			current_goal = (current_goal + 1) % len(positions)
			nextPosition = positions[current_goal]
			$Timer.start()
		
		motion = (nextPosition - global_position).normalized() * (MAX_SPEED * walk_speed)
		move_and_slide(motion)
		


func _on_Timer_timeout():
	blocked = false
