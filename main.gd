extends Node
#esta es la escena principal del juego, acá se desarrolla todo
#está la parte en que aram la trama, la envía y genera los otros jugadores


#variables
var timer = 0

# For client
var seq = -1
const CONNECT_ATTEMPTS = 20
var connected = false

var name_list = ["default"]
var nombre = null
var nombres_total = {}
var nuevo_player = true
var contador = 0
var total_jugadores = 0
var i =0


#esta clase la usa para la comunicacion
var packet_peer = PacketPeerUDP.new()
var connection = StreamPeerTCP.new()

func _ready():
	Globals.total_player = get_node("player").get_children()
	#start_client()
	print(get_node("/root/playervariables").ip)
	if (get_node("/root/playervariables").ip==null):
		print("null")
		get_node("/root/playervariables").ip="127.0.0.1"
	else:
		print(get_node("/root/playervariables").ip)
		
	connection.connect( get_node("/root/playervariables").ip, get_node("/root/playervariables").port)
	
	if connection.get_status() == connection.STATUS_CONNECTED:
		print ("Connected to "+get_node("/root/playervariables").ip+" :"+str(get_node("/root/playervariables").port) );
		set_process(true) # start processing if connected
		connected = true # finally you can use this var ;)
	elif connection.get_status() == StreamPeerTCP.STATUS_CONNECTING:
		print ("Trying to connect "+get_node("/root/playervariables").ip+" :"+str(get_node("/root/playervariables").port) )
		set_process(true) # or if trying to connect
	elif connection.get_status() == connection.STATUS_NONE or connection.get_status() == StreamPeerTCP.STATUS_ERROR:
		print ( "Couldn't connect to "+get_node("/root/playervariables").ip+" :"+str(get_node("/root/playervariables").port) )
	set_process(true)
	


func _process(delta):
	
	#---------------------acá armo la trama y la manda-----editada por martin-----------------
	# uso una variable de tiempo para enviar los datos con una tasa de refresco
	var duration = 1.0 / get_node("/root/playervariables").network_fps
	if (timer < duration):
		timer += delta
	else:
		timer = 0
		var packet = ["update", 1]
		for player in Globals.get("total_player"):
			packet.append([get_node("/root/playervariables").nombre_jugador, player.get_pos(), player.get_rot(),"final"])
			packet_peer.put_var(packet)
			#print("envio esto:")##################para debugg
			#print(packet)##################para debugg
		
	
	#Client update
	# Read snapshots from server and add it to a kinematic buffer (if interpolating),
	# or immediately update the local state (if not interpolating)
	while (packet_peer.get_available_packet_count() > 0):
		var packet = packet_peer.get_var()
		#print(packet) #esto lo agrega martin para ver que recibo
		
		if (packet == null):
			continue
		
		if (packet[0] == "update"):#es un player conectado
			#print("seq:",seq)
			if (packet[1] == 1):	#se está moviendo
				for i in range(2, packet.size()):
					var name_in = packet[i][0]
					var pos_in = packet[i][1]
					var rot_in = packet[i][2]
					var vel_in = packet[i][3]
					for i in range(0,total_jugadores) :################## busco si el personaje ya lo tengo creado
						get_node("externos").get_child(i).set_pos(pos_in)
					if (total_jugadores == 0):
						print("primero conectado")	##################para debugg
						var scene = load("res://ext_player/ext_player.scn")
						var new_player = scene.instance()
						new_player.set_name(name_in)
						get_node("externos").add_child(new_player)
						print("el nombre es:" + name_in)	################## para debugg
						total_jugadores = total_jugadores + 1
						
					for i in range(0,total_jugadores) :################## busco si el personaje ya lo tengo creado
						if (name_in == get_node("externos").get_child(i).get_name()):
							nuevo_player = false
							#print(get_node("externos").get_child(i).get_name())################## para debugg
							
							
						if (nuevo_player):
							var scene = load("res://ext_player/ext_player.scn")
							var new_player = scene.instance()
							new_player.set_name(name_in)
							get_node("externos").add_child(new_player)
							print(name_in)	##################
							total_jugadores = total_jugadores + 1
						
						nuevo_player = true
				#acá tengo que actualizar la posicion de los personajes
				var ubicacion = Vector2() 
				#print("posicion entrante" + pos_in)
				#for i in range(0,total_jugadores) :################## busco si el personaje ya lo tengo creado
				#get_node("externos").get_child(i).set_pos(pos_in)
			
			
	# Update interpolation and local state
	#if (interpolation):
	#	for box in boxes:
	#		var buffer = buffers[box.get_name()]
	#		buffer.update(delta)
	#		box.set_pos(buffer.get_pos())
	#		box.set_rot(buffer.get_rot())
	
	

##------------funciones---------------

# Set packet peer for player
func set_packet_peer_player(packet_peer):
	for player in Globals.total_player:
		player.packet_peer = packet_peer



func start_client():
	# Select a port for the client
	var client_port = 3000 + 1
	
	while (packet_peer.listen(client_port) != OK):
		client_port += 1
	
	# Set server address
	packet_peer.set_send_address('127.0.0.1', 3000)
	
	# Try to connect to server
	var attempts = 0
	var connected = false
	
	while (not connected and attempts < CONNECT_ATTEMPTS):
		attempts += 1
	
		packet_peer.put_var(["connect"])
		OS.delay_msec(50)
		
		while (packet_peer.get_available_packet_count() > 0):
			var packet = packet_peer.get_var()
			if (packet != null and packet[0] == "accepted"):
				connected = true
				break
	
	if (not connected):
		
		print("Error connecting to ", get_node("/root/playervariables").ip, ":", get_node("/root/playervariables").port)
		return
	else:
		print("Connected to ", get_node("/root/playervariables").ip, ":", get_node("/root/playervariables").port)
		#connect.set_text("Disconnect")
		#start.set_disabled(true)
		#set_host_boxes(false)
	
