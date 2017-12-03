extends Node2D

var enemies
var player

func _ready():
	enemies = get_tree().get_nodes_in_group("enemy")
	self.player =  get_tree().get_nodes_in_group("player")[0]
	set_fixed_process(true)

	
func _fixed_process(delta):
	if self.player.dead and !self.player.get_node("AnimationPlayer").is_playing():
		get_tree().set_pause(true)