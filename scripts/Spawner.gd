extends "base_enemy.gd"

var slimeScn = preload("res://scenes/monsters/Slime.tscn")

var cooldown
export var throuput = 2
var animation_length
var max_enemies = 0

func _ready():
	set_shape_as_trigger(0, true)
	self.life  = 1000 #useless
	self.cooldown = throuput
	self.animation_length = self.get_node("AnimationPlayer").get_animation("Spawn").get_length()
	self.max_enemies = get_parent().get_node("Enemies").max_enemies
	set_fixed_process(true)
	
func _fixed_process(delta):

	if get_parent().get_node("Enemies").is_max_reached() :
		return
	cooldown -= delta
	if cooldown <= animation_length and !self.get_node("AnimationPlayer").is_playing():
		self.get_node("AnimationPlayer").play("Spawn")

	if cooldown <= 0 :
		self.cooldown = throuput
		var new_monster = self.slimeScn.instance()
		new_monster.set_pos(self.get_pos())
		get_parent().get_node("Enemies").add_enemy(new_monster)
		self.get_node("AnimationPlayer").play("idle")

func take_damage(hit_rate):
	pass
	