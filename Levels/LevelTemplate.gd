extends Node2D

const ConnectionTypes = preload("res://Globals/ConnectionTypes.gd").ConnectionTypes

const CONECTION_COLOR = "b92121"

var connected_nodes = []

func _ready():
	add_to_group("GameController")

func _process(delta):
	update()

func addConnection(node, type):
	# if there is no connection, will only create a conection if the node
	# it is a source
	if connected_nodes.size() == 0 and ConnectionTypes.SOURCE != type:
		return
		
	if not connected_nodes.has(node):
		connected_nodes.append(node)
	elif connected_nodes[connected_nodes.size() - 1] == node:
		connected_nodes.remove(connected_nodes.size() -1)

func _draw():
	var n1
	var n2

	if connected_nodes.size() > 1:
		for i in range(connected_nodes.size() - 1):
			n1 = connected_nodes[i]
			n2 = connected_nodes[i + 1]
			
			drawConnection(n1.position, n2.position)
			
	if connected_nodes.size() > 0:
		var last_connection = connected_nodes[connected_nodes.size() -1]
		
		drawConnection($Player.position, last_connection.position)
		

func drawConnection(pos1, pos2):
	draw_line(pos1, pos2, CONECTION_COLOR)
