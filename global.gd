extends Node

#script global
#agregar estado de sincr.. 

#Explicacion de la trama
#	0	|	1	|	2		|	3	|	4	|	5	|	6	|
#estado|	id	|	nombre	|posx	|posy	|		|		|
#
#Estado:
#connect= es un player conectado
#ID:
#1= se está moviendo, tengo que actualizar la pos

#The currently active scene
var currentScene = null
#variables de config global
const CONNECT_ATTEMPTS = 20

var InterpolationBuffer = load("interpolationbuffer.gd")

var buffers_initialized = false
var interpolation = false
var timer = 0
var host = true
var ready = false
var start = null
var connect = null


#esta clase la usa para la comunicacion
#var packet_peer = PacketPeerUDP.new()

# For server
var clients = []

# For client
var seq = -1

var name_list = ["default"]
var nombre = null
var nombres_total = {}
var nuevo_player = true
var contador = 0
var total_jugadores = 0
var i =0

var total_player = null

#Esto me parece que hay que sacarlo... #sacar1
# Kinematic buffers for each of the boxes
#var buffers = {}


func _ready():
	#On load set the current scene to the last scene available
	currentScene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() -1)
	
	#set_packet_peer_player(packet_peer)
	
	load_defaults()
	##sacar1
	#for player in total_player:
	#	buffers[player.get_name()] = InterpolationBuffer.new(window.get_value())
	
	
	buffers_initialized = true
	
	set_process(true)
	
	for arg in OS.get_cmdline_args():
		if (arg == "-server"):
			start_server()
			break
	

#######################-----funciones---------###########################

# para cambiar de escena
func setScene(scene):
	#borrar la escena actual
	currentScene.queue_free()
	#cargar la escena "scene"
	var pantalla = ResourceLoader.load(scene)
	#crear la instancia de la escena
	currentScene = pantalla.instance()
	# agregar la escena a root
	get_tree().get_root().add_child(currentScene)
	

func load_defaults():
	var config_file = ConfigFile.new()
	config_file.load("res://defaults.cfg")
	
	get_node("/root/playervariables").ip=config_file.get_value("defaults", "ip")
	get_node("/root/playervariables").port=config_file.get_value("defaults", "port")
	get_node("/root/playervariables").window=config_file.get_value("defaults", "window")
	get_node("/root/playervariables").network_fps=config_file.get_value("defaults", "network_fps")
	

#magia oscura >:)
#func set_packet_peer_player(packet_peer):
#	for player in total_player:
#		player.packet_peer = packet_peer
