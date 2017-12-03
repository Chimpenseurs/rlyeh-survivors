extends "base_enemy.gd"

var damages = 500
func _ready():

	set_fixed_process(true)

func _fixed_process(delta):
	var player = get_tree().get_nodes_in_group("player")[0]
	var player_pos = player.get_pos()
	
	var path = get_tree().get_nodes_in_group("map")[0].get_simple_path(player_pos, get_pos())
	
	if path.size() > 1 :
		var direction = path[0] - get_pos()
		
		if direction.x < 0 :
			self.scale(Vector2(-1, 1))
		else : 
			self.scale(Vector2(1, 1))
		
		# Attack
		if player != null :
			var player_rect = player.get_item_rect()
			player_rect.pos += player_pos
			var cross_pos = get_pos() + get_scale()*get_node("Position2D").get_pos()
		
			if player_rect.has_point(cross_pos) :
				get_node("AnimationPlayer").play("attack")
				player.take_damage(get_pos(), self.damages)
	
		var motion = direction.normalized() * velocity * delta 
		self.move(motion)
	
		if (is_colliding()):
			if get_collider() == player :
				get_collider().take_damage(get_pos(), self.damages)
			
			var n = get_collision_normal()
			motion = n.slide(motion)
			self.move(motion)