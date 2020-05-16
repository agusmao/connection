extends Node2D

export(String) var nextLevel = "1"

const ConnectionTypes = preload("res://Globals/ConnectionTypes.gd").ConnectionTypes
const CONECTION_COLOR = "1f62ff"
const CONECTION_BLOCKER_COLOR = "fa160a"
const MAX_DISTANCE = 300
const WIRE_WIDTH = 4

var isGameOver = false
var connected_nodes = []
var playerIsConnected = false
var blockers_connected = []

var timeElapseSinceGameOver = 0.0
var isShowingNextLevelUI = false

func _ready():
	add_to_group("GameController")
	
	for child1 in $YSort/Blockers.get_children():
		for child2 in $YSort/Blockers.get_children():
			if child2.id == child1.connected_to:
				blockers_connected.append([child1, child2])

func _process(delta):
	# Gives a small delay after connecting the lamp so the animation appears
	if isGameOver && timeElapseSinceGameOver > 3 && isShowingNextLevelUI == false:
		# Loads next level UI
		get_node("CanvasLayer/EndGameUI").show()
		isShowingNextLevelUI = true
	elif isGameOver:
		timeElapseSinceGameOver += delta
	
	update()
	
	# if distance from the last node and the player it is too far, cut connection with the player
	if connected_nodes.size() > 0 and $YSort/Player.global_position.distance_to(connected_nodes[connected_nodes.size() - 1].global_position) > MAX_DISTANCE:
		playerIsConnected = false
	
func _physics_process(delta):
	if someConnectionCrossBlocker():
		for i in range(0, connected_nodes.size()):
			if connected_nodes[i].has_method("toggleConnection"):
				connected_nodes[i].toggleConnection(false)
		connected_nodes.clear()
		playerIsConnected = false
	
func someConnectionCrossBlocker():
	var n1
	var n2
	if connected_nodes.size() > 1:
		for i in range(connected_nodes.size() - 1):
			n1 = connected_nodes[i]
			n2 = connected_nodes[i + 1]
			if haveBlocker(n1.global_position, n2.global_position):
				return true
	if connected_nodes.size() > 0:
		n1 = connected_nodes[connected_nodes.size() - 1]
		n2 = $YSort/Player
		if haveBlocker(n1.global_position, n2.global_position):
			return true
	return false

func haveBlocker(pos1, pos2):
	var space = get_world_2d().direct_space_state

	var obstacle = space.intersect_ray(pos1, pos2, [], 4, true, true)
	
	if not obstacle:
		for c in blockers_connected:
			var b1pos = c[0].position
			var b2pos = c[1].position
			
			var res = Geometry.line_intersects_line_2d(b1pos, b2pos - b1pos, pos1, pos2 - pos1)
			if res and isPosInLine(res, b1pos, b2pos) and isPosInLine(res, pos1, pos2):
				c[0].animateAbsorving()
				c[1].animateAbsorving()
				return true

		return false
	else:
		obstacle.collider.animateAbsorving()
		return true

func isPosInLine(pos, from, to):
	var fromX
	var toX
	var fromY
	var toY
	
	if from.x < to.x:
		fromX = from.x
		toX = to.x
	else:
		fromX = to.x
		toX = from.x

	if from.y < to.y:
		fromY = from.y
		toY = to.y
	else:
		fromY = to.y
		toY = from.y
	
	return pos.x >= fromX and pos.x <= toX and pos.y >= fromY and pos.y <= toY

func addConnection(node, type):
	# if there is no connection, will only create a conection if the node
	# it is a source
	if connected_nodes.size() == 0 and ConnectionTypes.SOURCE != type:
		return
	
	# if we don't have this node already on connected nodes, we just add it
	if not connected_nodes.has(node):
		if type == ConnectionTypes.SOURCE:
			playerIsConnected = true
			connected_nodes.append(node)
		elif type == ConnectionTypes.NORMAL && playerIsConnected:
			node.toggleConnection(true)
			connected_nodes.append(node)
		elif type == ConnectionTypes.GOAL && playerIsConnected:
			connected_nodes.append(node)
			node.toggleConnection(false)
			# If we reach the end level when connected
			endGame()
	else:
		# In case the player it is disconected, the player can reconect to node
		# but ignore the nodes ahead of this one
		if not playerIsConnected:
			var nodePosition = connected_nodes.find(node, 0)
			for i in range(nodePosition+1, connected_nodes.size()):
				if connected_nodes[i].has_method("toggleConnection"):
					connected_nodes[i].toggleConnection(false)
			connected_nodes = connected_nodes.slice(0, nodePosition)
			playerIsConnected = true
		# this else remove if the player touches a already connected node, if 
		# it is the last one
		elif connected_nodes[connected_nodes.size() - 1] == node:
			connected_nodes.remove(connected_nodes.size() -1)
			if node.has_method("toggleConnection"):
				node.toggleConnection(false)

func endGame():
	# Calls the endgame UI
	isGameOver = true
	# Disable the users input
	$YSort/Player.isMovementAllowed = false
	
	get_tree().call_group("GameStatus", "finishedLevel")

func _draw():
	var n1
	var n2

	if connected_nodes.size() > 1:
		for i in range(connected_nodes.size() - 1):
			n1 = connected_nodes[i]
			n2 = connected_nodes[i + 1]
			
			
			
			drawConnection(n1.global_position, n2.global_position)
			
	if connected_nodes.size() > 0 and playerIsConnected:
		var last_connection = connected_nodes[connected_nodes.size() -1]
		drawConnection($YSort/Player.global_position, last_connection.global_position)

	for blockPairs in blockers_connected:
		drawBlockerConnection(blockPairs[0].global_position, blockPairs[1].global_position)
		

func drawConnection(pos1, pos2):
	var distance = pos1.distance_to(pos2)
	var currentWidth = WIRE_WIDTH + WIRE_WIDTH * abs( cos( OS.get_ticks_msec() / 100 ) )
	var lineWidth = clamp((MAX_DISTANCE/(distance * 2) ) * currentWidth, 0.2, WIRE_WIDTH * 4)
	
	draw_line(pos1, pos2, CONECTION_COLOR, lineWidth)
	
func drawBlockerConnection(pos1, pos2):
	var distance = pos1.distance_to(pos2)
	if distance > 0:
		var currentWidth = WIRE_WIDTH + WIRE_WIDTH * abs( cos( OS.get_ticks_msec() / 100 ) )
		var lineWidth = clamp((MAX_DISTANCE/(distance * 2) ) * currentWidth, 0.2, WIRE_WIDTH * 4)
		draw_line(pos1, pos2, CONECTION_BLOCKER_COLOR, lineWidth)

func _on_NextLevelButton_pressed() -> void:
	# Load the next level
	onNextLevel()
	# get_tree().change_scene("res://Levels/LevelTemplate.tscn") # Use the currentLevel var as reference
	
func onNextLevel():
	get_tree().change_scene("res://Levels/"+ nextLevel) # Use the currentLevel var as reference
