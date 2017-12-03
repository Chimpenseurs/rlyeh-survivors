extends Node2D

enum MAPS {
	DeadEnd,
	CrossRoad
}

var currentRoomIdx = Vector2(1, 1)
var world = [
	[ MAPS.CrossRoad, MAPS.CrossRoad, MAPS.CrossRoad],
	[ MAPS.DeadEnd, MAPS.DeadEnd, MAPS.CrossRoad],
	[ MAPS.CrossRoad, MAPS.CrossRoad, MAPS.CrossRoad]
		]
			
const Maps = {
	MAPS.DeadEnd: preload("res://scenes/rooms/DeadEnd.tscn"),
	MAPS.CrossRoad : preload("res://scenes/rooms/CrossRoad.tscn")
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
	
	self.currentRoom = self.Maps[get_room(currentRoomIdx)].instance()
	self.currentRoom.add_to_group("map")
	self.currentRoom.set_z(self.currentRoom.get_z() - 1)
	
	self.add_child(currentRoom)
	self.add_child(player)

func get_direction_vector(direction):
	if direction == "left":
		return Vector2(-1, 0)
	if direction == "right":
		return Vector2(1, 0)
	if direction == "bottom":
		return Vector2(0, -1)
	if direction == "up":
		return Vector2(0, 1)

func get_room(pos):
	return self.world[pos.x][pos.y]
	
func change_room(pos, direction):
	create_bullet_holder()
	print(currentRoomIdx)
	
	var direction_vector = get_direction_vector(direction)
	
	self.currentRoomIdx += direction_vector
	var room = get_room(self.currentRoomIdx)
	
	var tmp_room = self.currentRoom
	self.currentRoom = Maps[room].instance()
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
	var direction = null
	
	if player.get_pos().x < 0 :
		new_pos.x = viewport_rect.size.width - 10
		direction = "left"
	elif player.get_pos().x > viewport_rect.size.width :
		new_pos.x = 10
		direction = "right"
	elif player.get_pos().y < 0 :
		new_pos.y = viewport_rect.size.height - 10
		direction = "bottom"
	elif player.get_pos().y > viewport_rect.size.height :
		new_pos.y = 10
		direction = "up"
		
	if new_pos != player.get_pos():
		self.change_room(new_pos, direction)
