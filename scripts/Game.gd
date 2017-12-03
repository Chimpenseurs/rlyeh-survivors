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
	
	# Move camera
	var camera_pos = get_node("Camera2D").get_camera_pos()
	var visible_rect = get_node("Camera2D").get_viewport().get_visible_rect()
	
	# To the left
	if player.get_pos().x < camera_pos.x :
		var slide = Vector2(-visible_rect.size.width, 0)
		var new_pos = camera_pos + slide 
		get_node("Camera2D").set_pos(new_pos)