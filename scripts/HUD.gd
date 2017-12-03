extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	
	var player = get_tree().get_nodes_in_group("player")[0]
	
	var nb = player.devil_hearts
	var label = get_node("collectable/devil_heart/Label")
	if nb != int(label.get_text()):
		label.set_text(int_to_text(nb))
		
	nb = player.devil_shoes
	label = get_node("collectable/devil_shoes/Label")
	if nb != int(label.get_text()):
		label.set_text(int_to_text(nb))
		
	nb = player.devil_eyes
	label = get_node("collectable/devil_eyes/Label")
	if nb != int(label.get_text()):
		label.set_text(int_to_text(nb))

func int_to_text(val) :
	return String(val / 100) + String((val % 100) / 10) + String((val % 100) % 10)
