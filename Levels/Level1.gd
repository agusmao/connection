extends "res://Levels/LevelTemplate.gd"

func onNextLevel():
	get_tree().change_scene("res://Levels/Level2.tscn") # Use the currentLevel var as reference
