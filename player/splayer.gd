
extends KinematicBody2D

const EVENT_START_DRAG = 0
const EVENT_END_DRAG = 1
const EVENT_DRAGGING = 2

const SCALE_FACTOR = 25

var dragging = false
var host = true;
var packet_peer = null

#pixels / second
const MOTION_SPEED=160

func _ready():
	set_fixed_process(true)
	pass

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
	


