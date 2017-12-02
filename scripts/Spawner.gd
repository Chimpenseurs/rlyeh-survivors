extends Sprite

var slimeScn = preload("res://scenes/slime.tscn")

var cooldown = 1
var throuput = 1

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	cooldown -= delta
	if cooldown <= 0:
		self.cooldown = throuput
		var new_monster = self.slimeScn.instance()
		new_monster.set_pos(self.get_pos())
		get_parent().get_node("Enemies").add_child(new_monster)