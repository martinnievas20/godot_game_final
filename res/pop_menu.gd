
extends PopupPanel

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	get_node("item_1_cantidad").set_text(str(get_node("/root/playervariables").item_1))
	set_process(true)
	

func _process(delta):
	pass

