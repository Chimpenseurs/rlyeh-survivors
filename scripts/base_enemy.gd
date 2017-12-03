extends KinematicBody2D

const items = [preload("res://scenes/Hearth.tscn"), 
preload("res://scenes/Eye.tscn"),
preload("res://scenes/Shoe.tscn")]

var life = 100
var velocity = 100

func _ready():
	print(get_name())
	add_to_group("enemy")

func die():
	randomize()
	if randf() < 0.15:
		var item = items[randi() % items.size()].instance()
		item.set_pos(self.get_pos())
		get_tree().get_nodes_in_group("map")[0].add_child(item)
	self.queue_free()

func take_damage(hit_rate):
	self.life -= hit_rate
	if self.life <= 0:
		self.die()
