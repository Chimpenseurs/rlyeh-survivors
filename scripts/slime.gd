extends KinematicBody2D

# class member variables go here, for example:
const velocity = 100

func _ready():
	add_to_group("enemies")
	set_fixed_process(true)

func _fixed_process(delta):
	var player_pos = get_parent().get_node("Avatar").get_pos()
	
	var path = get_parent().get_simple_path(player_pos, get_pos())
	
	if path.size() > 1 :
		var direction = path[0] - get_pos()
	
		var motion = direction.normalized() * velocity * delta 
		self.move(motion)
	
		if (is_colliding()):
			if get_collider().get_name() == "Avatar" :
				get_collider().take_damage(get_pos())
			
			var n = get_collision_normal()
			motion = n.slide(motion)
			self.move(motion)
