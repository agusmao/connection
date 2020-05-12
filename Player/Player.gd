extends KinematicBody2D

const SPEED = 15
const INERTIA = 0.16
const MAX_SPEED = 500

var motion = Vector2()
var isMovementAllowed = true
var isFacingRight = true

func _physics_process(delta):
	if isMovementAllowed == false:
		return
	
	if Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		motion.x = clamp(motion.x - SPEED, -MAX_SPEED, 0)
	elif Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
		motion.x = clamp(motion.x + SPEED, 0, MAX_SPEED)
	else:
		motion.x = lerp(motion.x, 0, INERTIA)

	if Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_down"):
		motion.y = clamp(motion.y - SPEED, -MAX_SPEED, 0)
	elif Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_up"):
		motion.y = clamp(motion.y + SPEED, 0, MAX_SPEED)
	else: 
		motion.y = lerp(motion.y, 0, INERTIA)
		
	if abs(motion.x) - 5.0 > 0 || abs(motion.y) - 5.0 > 0:
		playAnimation("moving")
		if motion.x > 0:
			isFacingRight = true
		elif motion.x < 0:
			isFacingRight = false
	else:
		playAnimation("idle")
		
	$AnimatedSprite.flip_h = !isFacingRight

	move_and_slide(motion)

func playAnimation(name):
	if $AnimatedSprite.animation != name:
		$AnimatedSprite.play(name)
