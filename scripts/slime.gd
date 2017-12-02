extends KinematicBody2D

# class member variables go here, for example:
const velocity = 100

var life = 100

func _ready():
	add_to_group("enemies")
	set_fixed_process(true)

func _fixed_process(delta):
	var player_pos = get_parent().get_node("Avatar").get_pos()
	
	var path = get_parent().get_simple_path(player_pos, get_pos())
	
	if path.size() > 1 :
		var direction = path[0] - get_pos()
		
		if direction.x < 0 :
			self.scale(Vector2(-1, 1))
		else : 
			self.scale(Vector2(1, 1))
		
		var motion = direction.normalized() * velocity * delta 
		self.move(motion)
	
		if (is_colliding()):
			if get_collider().get_name() == "Avatar" :
				get_collider().take_damage(get_pos())
			
			var n = get_collision_normal()
			motion = n.slide(motion)
			self.move(motion)

func take_damage(hit_rate):
	self.life -= hit_rate
	if self.life <= 0:
		self.queue_free()