extends Node

#Pantalla de bienvenida

func _ready():
   set_process(true)
   
func _process(delta):
   if(Input.is_mouse_button_pressed(BUTTON_LEFT)):
      get_node("/root/global").setScene("res://menu.scn")


