extends KinematicBody2D

# class member variables go here, for example:
const velocity = 100

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var player_pos = get_parent().get_node("Avatar").get_pos()
	
	var path = get_parent().get_simple_path(player_pos, get_pos())
	
	var direction = path[0] - get_pos()
	
	self.move(direction.normalized() * velocity * delta)
