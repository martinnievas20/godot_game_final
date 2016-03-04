
extends KinematicBody2D

var name = "Unnamed"
var controlled = false
var anim = "Idle"
var points = []
var pos = Vector2(0,0)
#inventario
var vida = 100
var energia = 0

#pixels / second
const MOTION_SPEED=160

func MakePlayer():
	controlled = true
	#get_node("Camera2D").set_zoom(get_node("Camera2D").get_zoom() * get_node("/root/global").viewport_scale) # Setear zoom adaptable a pantalla
	get_node("Camera2D").make_current()

func _fixed_process(delta):
	get_node("Camera2D").make_current()
	var motion = Vector2()
	
	if (Input.is_action_pressed("move_up")):
		motion+=Vector2(0,-1)
	if (Input.is_action_pressed("move_bottom")):
		motion+=Vector2(0,1)
	if (Input.is_action_pressed("move_left")):
		motion+=Vector2(-1,0)
	if (Input.is_action_pressed("move_right")):
		motion+=Vector2(1,0)
	
	motion = motion.normalized() * MOTION_SPEED * delta
	motion = move(motion)
	
	#make character slide nicely through the world	
	var slide_attempts = 4
	while(is_colliding() and slide_attempts>0):
		motion = get_collision_normal().slide(motion)
		motion=move(motion)
		slide_attempts-=1
	
#get_node("Camera2D").get_zoom() * 
func _ready():
	set_fixed_process(true)
	#get_node("Camera2D").set_zoom(get_node("Camera2D").get_zoom() * get_node("/root/main").viewport_scale) # Setear zoom adaptable a pantalla
	add_to_group("Players")
	#get_node("Nametag").set_text(name)


