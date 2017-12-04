extends Node2D

export var max_enemies = 7

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func add_enemy(node):
	if self.get_child_count() < self.max_enemies:
		self.add_child(node)
	else:
		print("ezrezr")
		node.queue_free()
		
func is_max_reached():
	return self.get_child_count() >= self.max_enemies