extends KinematicBody2D

const items = {"heart": preload("res://scenes/collectables/Heart.tscn"), 
"eye": preload("res://scenes/collectables/Eye.tscn"),
"shoe": preload("res://scenes/collectables/Shoe.tscn")}

var life = 100
var velocity = 100

func _ready():
	add_to_group("enemy")

func die():
	randomize()
	if randf() < 0.5 :
		var item 
		var rand = randf()
		if rand < 0.1 : 
			item = items["eye"].instance()
		if rand >= 0.1 && rand < 0.3 : 
			item = items["shoe"].instance()
		else :
			item = items["heart"].instance()
			
		item.set_pos(self.get_pos())
		get_tree().get_nodes_in_group("map")[0].add_child(item)
	
	var enemies_killed = get_tree().get_nodes_in_group("scores")[0]
	var nb = int(enemies_killed.get_text()) + 1
	enemies_killed.set_text(String(nb / 1000) + String((nb % 1000) / 100) + String((nb % 100) / 10) + String(nb % 10))
	
	self.queue_free()

func take_damage(hit_rate):
	self.life -= hit_rate
	if self.life <= 0:
		self.die()
