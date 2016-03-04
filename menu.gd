
extends Node

var tamano = 0
#acá van las cosas de la configuración y demás....
#agregar botones

func _ready():
	#get_node("Button_ingresar").set_pos(get_node("."))
	pass

func _process(delta):
	pass


func _on_Button_ingresar_pressed():
	get_node("/root/global").setScene("res://main.scn")


func _on_Button_acerca_de_pressed():
	get_node("/root/global").setScene("res://res/acerca_de.scn")


func _on_Button_config_pressed():
	get_node("/root/global").setScene("res://res/config.scn")
