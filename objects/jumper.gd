extends Area2D

signal capturado
onready var cola = $cola/puntitos
# Declare member variables here. Examples: 
var velocity = Vector2(100, 0)
var salto = 1000
var target = null
var cant_puntitos = 15

func _unhandled_input(event):
	if target and event is InputEventScreenTouch and event.pressed:
		jump()

func jump():
	target.implosion()
	target = null
	velocity = transform.x * salto

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_jumper_area_entered(area):
	target = area #el area es el siguiente circulo 
	#seteo el pivot del circulo a la pos actual del jugador
	#va en circle pero al reves
	#target.get_node("pivot").rotation = (position - target.position).angle()
	velocity = Vector2.ZERO
	emit_signal("capturado",area)
func _physics_process(delta):
	if cola.points.size() > cant_puntitos:
		cola.remove_point(0)
	cola.add_point(position)
	if target:
		transform = target.orbit_position.global_transform #tomamos el valor del punto 2d que sirve de ref de orbita
	else:
		position += velocity * delta #nos movemos continuamente
		#print(position)


func die():
	target = null
	queue_free()


func _on_screen_exited():
	if !target:
		die()
		#escena actual (Main)
		get_tree().reload_current_scene()
