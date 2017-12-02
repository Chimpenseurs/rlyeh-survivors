extends KinematicBody2D

const hearthItem = preload("res://scenes/Hearth.tscn")
const velocity = 100

var life = 100

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
			var cross_pos = get_pos() + get_scale()*get_node("Position2D").get_pos()
		
			if cross_pos.x > player_pos.x - player_rect.size.width / 2 \
			&& cross_pos.x < player_pos.x + player_rect.size.width / 2 \
			&& cross_pos.y > player_pos.y - player_rect.size.height / 2 \
			&& cross_pos.y < player_pos.y + player_rect.size.height / 2 :
				get_node("AnimationPlayer").play("attack")
				player.take_damage(get_pos())
	
		var motion = direction.normalized() * velocity * delta 
		self.move(motion)
	
		if (is_colliding()):
			if get_collider() == player :
				get_collider().take_damage(get_pos())
			
			var n = get_collision_normal()
			motion = n.slide(motion)
			self.move(motion)
	
	

func take_damage(hit_rate):
	self.life -= hit_rate
	if self.life <= 0:
		self.die()
		
func die():
	var drop = floor(rand_range(1, 11))
	if drop >= 9:
		var item = hearthItem.instance()
		item.set_pos(self.get_pos())
		get_tree().get_nodes_in_group("map")[0].add_child(item)

	self.queue_free()