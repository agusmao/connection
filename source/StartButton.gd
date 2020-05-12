extends Button

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Fade_In_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "fade_in":
		get_tree().change_scene("res://Levels/Level1.tscn")
