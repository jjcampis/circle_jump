extends Node

var Circle = preload("res://objects/Circle.tscn")

var Jumper = preload("res://objects/jumper.tscn")
var player
#var gamestarted = null

func _ready():
	randomize()
	new_game()
#	if !gamestarted:	
#		new_game()
#		gamestarted = true
#		print("start")
#	if start == false:
#		new_game()
#		start = true
		

func new_game():
	$Camera2D.position = $start.position
	player = Jumper.instance()
	player.position = $start.position
	add_child(player)
	player.connect("capturado",self,"on_jumper_capturado")
	spawn_circle($start.position)
	
func spawn_circle(_position=null):
	var c = Circle.instance()
	if !_position:
		var x = rand_range(-150,150)
		var y = rand_range(-500,-400)
		_position = player.position + Vector2(x,y)
	add_child(c)
	c.init(_position)
	
func on_jumper_capturado(object):
	$Camera2D.position = object.position
	#spawn_circle() #no puedo hacer esto en el phisycs process
	object.capturado(player)
	call_deferred("spawn_circle")
	
