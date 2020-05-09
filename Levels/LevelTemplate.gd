extends Node2D

export(String) var currentLevel = "1"

const ConnectionTypes = preload("res://Globals/ConnectionTypes.gd").ConnectionTypes

const CONECTION_COLOR = "b92121"

const MAX_DISTANCE = 400

var connected_nodes = []
var playerIsConnected = false

func _ready():
	add_to_group("GameController")

func _process(delta):
	update()
	
	# if distance from the last node and the player it is too far, cut connection with the player
	if connected_nodes.size() > 0 and $Player.global_position.distance_to(connected_nodes[connected_nodes.size() - 1].global_position) > MAX_DISTANCE:
		playerIsConnected = false
	
func _physics_process(delta):
	if someConnectionCrossBlocker():
		connected_nodes.clear()
	
func someConnectionCrossBlocker():
	var n1
	var n2
	if connected_nodes.size() > 1:
		for i in range(connected_nodes.size() - 1):
			n1 = connected_nodes[i]
			n2 = connected_nodes[i + 1]
			if haveBlocker(n1.global_position, n2.global_position):
				return true
		n1 = connected_nodes[connected_nodes.size() - 1]
		n2 = $Player
		if haveBlocker(n1.global_position, n2.global_position):
			return true
	return false

func haveBlocker(pos1, pos2):
	var space = get_world_2d().direct_space_state

	var obstacle = space.intersect_ray(pos1, pos2, [], 4, true, true)
	
	if not obstacle:
		return false
	else:
		return true

func addConnection(node, type):
	# if there is no connection, will only create a conection if the node
	# it is a source
	if connected_nodes.size() == 0 and ConnectionTypes.SOURCE != type:
		return
	
	# if we don't have this node already on connected nodes, we just add it
	if not connected_nodes.has(node):
		connected_nodes.append(node)
		playerIsConnected = true
	else:
		# In case the player it is disconected, the player can reconect to node
		# but ignore the nodes ahead of this one
		if not playerIsConnected:
			var nodePosition = connected_nodes.find(node, 0)
			connected_nodes = connected_nodes.slice(0, nodePosition)
			playerIsConnected = true
		# this else remove if the player touches a already connected node, if 
		# it is the last one
		elif connected_nodes[connected_nodes.size() - 1] == node:
			connected_nodes.remove(connected_nodes.size() -1)

func endGame():
	# Calls the endgame UI
	get_node("CanvasLayer/EndGameUI").show()
	# Disable the users input
	get_node("Player").isMovementAllowed = false

func _draw():
	var n1
	var n2

	if connected_nodes.size() > 1:
		for i in range(connected_nodes.size() - 1):
			n1 = connected_nodes[i]
			n2 = connected_nodes[i + 1]
			
			drawConnection(n1.position, n2.position)
			
	if connected_nodes.size() > 0 and playerIsConnected:
		var last_connection = connected_nodes[connected_nodes.size() -1]
		drawConnection($Player.position, last_connection.position)
		

func drawConnection(pos1, pos2):
	draw_line(pos1, pos2, CONECTION_COLOR)


func _on_NextLevelButton_pressed() -> void:
	# Load the next level
	get_tree().change_scene("res://Levels/LevelTemplate.tscn") # Use the currentLevel var as reference
