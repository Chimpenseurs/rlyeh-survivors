extends KinematicBody2D

const hearthItem = preload("res://scenes/Hearth.tscn")

var life = 100
var velocity = 100

func _ready():
	print(get_name())
	add_to_group("enemy")

func die():
	var drop = floor(rand_range(1, 11))
	if drop >= 9:
		var item = hearthItem.instance()
		item.set_pos(self.get_pos())
		get_tree().get_nodes_in_group("map")[0].add_child(item)
	self.queue_free()

func take_damage(hit_rate):
	self.life -= hit_rate
	if self.life <= 0:
		self.die()
