extends Node2D

var Maps = {
	"Map": preload("res://scenes/Map.tscn"),
	"Map3": preload("res://scenes/Map3Spawner.tscn")
}

var PlayerTscn = preload("res://scenes/Avatar.tscn")

var bullerHolder = null
var player
var currentRoom

func create_bullet_holder():
	if self.bullerHolder!= null:
		self.bullerHolder.queue_free()
		
	self.bullerHolder = Node2D.new()
	self.bullerHolder.set_name("BulletHolder")
	self.bullerHolder.set_as_toplevel(true)
	self.add_child(self.bullerHolder)

func _ready():
	self.set_fixed_process(true)
	create_bullet_holder()
	
	self.player = PlayerTscn.instance()
	self.player.set_pos(Vector2(100, 100))
	self.player.add_to_group("player")
	self.player.set_as_toplevel(true)
	
	self.currentRoom = Maps["Map"].instance()
	self.currentRoom.add_to_group("map")
	self.currentRoom.set_z(self.currentRoom.get_z() - 1)
	
	self.add_child(currentRoom)
	self.add_child(player)
	
	get_node("HUD").init_life_bar()

func change_room(name, pos):
	create_bullet_holder()
	
	var tmp_room = self.currentRoom
	self.currentRoom = Maps[name].instance()
	tmp_room.queue_free()
	
	self.currentRoom.add_to_group("map")
	self.add_child(self.currentRoom)
	self.currentRoom.set_z(self.currentRoom.get_z() - 1)
	
	self.player.set_pos(pos)
	
func _fixed_process(delta):
	if self.player.dead and !self.player.get_node("AnimationPlayer").is_playing():
		get_tree().set_pause(true)
	
	
	var viewport_rect = get_viewport_rect()
	var new_pos = player.get_pos()
	if player.get_pos().x < 0 :
		new_pos.x = viewport_rect.size.width - 10
	elif player.get_pos().x > viewport_rect.size.width :
		new_pos.x = 10
	elif player.get_pos().y < 0 :
		new_pos.y = viewport_rect.size.height - 10
	elif player.get_pos().y > viewport_rect.size.height :
		new_pos.y = 10
	
	if new_pos != player.get_pos():
		self.change_room("Map3", new_pos)
