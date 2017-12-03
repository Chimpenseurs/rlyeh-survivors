extends "base_enemy.gd"

var slimeScn = preload("res://scenes/slime.tscn")

var cooldown
var throuput = 5

func _ready():
	set_shape_as_trigger(0, true)
	self.life  = 1000
	self.cooldown = throuput
	set_fixed_process(true)
	
func _fixed_process(delta):
	cooldown -= delta
	if cooldown <= 0:
		self.cooldown = throuput
		var new_monster = self.slimeScn.instance()
		new_monster.set_pos(self.get_pos())
		get_parent().get_node("Enemies").add_child(new_monster)