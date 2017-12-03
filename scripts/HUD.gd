extends Control

var lifeHud
var player

func _ready():
	set_fixed_process(true)
	lifeHud = self.get_node("Control/Label")
	
func _fixed_process(delta):
	self.player =  get_tree().get_nodes_in_group("player")[0]
	lifeHud.set_text(String(self.player.life))