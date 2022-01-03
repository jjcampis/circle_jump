extends Area2D

onready var orbit_position = $pivot/OrbitPosition

enum MODES {estatico,limitado}
var radio = 100
var vel_rot = PI
#tut 3
var mode = MODES.estatico
var num_orbitas = 3
var current_orbitas = 0
var orbit_start = null
#para checkear si esta o no el jugador en el circulo actual
var jumper = null
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func init(_position, _radio=radio, _mode=MODES.limitado):#_radio es local en la func sino toma el valor declarado arriba
	set_mode(_mode)
	position = _position
	radio = _radio #aca es al reves porque toma lo que se haya asignado en los params
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate() #es lo mismo que hacer unico (en el main cuando instanciamos)
	$CollisionShape2D.shape.radius = radio
	var tam_img = $Sprite.texture.get_size().x / 2
	$Sprite.scale = Vector2(1,1) * radio / tam_img #el vector2 es el tamaño normal de la img luego multiplico por la proporcion de aspecto
	#proporcion de aspecto la saco de el radio / tam_img
	orbit_position.position.x = radio + 25
	#aleatoriedad en la rotacion
	vel_rot *= pow(-1,randi()%2) 

func set_mode(_mode):
	mode = _mode
	match mode:
		MODES.estatico:
			$Label.hide()
		MODES.limitado:
			current_orbitas = num_orbitas
			$Label.text = str(current_orbitas)
			$Label.show()
			
	
func implosion():
	$AnimationPlayer.play("implosion")
	yield($AnimationPlayer,"animation_finished")#reanuda ejecucion de script cuando termina la animacion
	queue_free()

func capturado(jugador):
	jumper = jugador
	$AnimationPlayer.play("capturado")
	#seteo el pivot a la posicion actual del jugador, tambien la posicion de la siguiente vuelta
	$pivot.rotation = (jugador.position - position).angle()
	orbit_start = $pivot.rotation
	#yield($AnimationPlayer,"animation_finished")#reanuda ejecucion de script cuando termina la animacion
	#queue_free()
	

func _process(delta):
	$pivot.rotation += vel_rot * delta 
	if mode == MODES.limitado and jumper:
		check_vuelta()
		
func check_vuelta():
	if abs($pivot.rotation - orbit_start) > 2 * PI:
		current_orbitas -= 1
		$Label.text = str(current_orbitas)
		if current_orbitas <= 0:
			jumper.die()
			jumper = null
			implosion()
		orbit_start = $pivot.rotation
