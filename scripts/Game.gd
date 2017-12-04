extends Node2D

enum MAPS {
	CornerBotLeft,
	CornerMap,
	CrossRoadBot,
	CornerRightTop,
	CornerTopLeft,
	CrossRoad,
	DeadEnd,
	LeftEnd,
	LeftMiddle,
	RightMiddle,
	Map3Spawner,
	RightEnd,
	ShopRoom,
	TopEnd
}

const Maps = {
	MAPS.CornerBotLeft: preload("res://scenes/rooms/CornerBotLeft.tscn"),
	MAPS.CornerMap: preload("res://scenes/rooms/CornerMap.tscn"),
	MAPS.CornerRightTop: preload("res://scenes/rooms/CornerRightTop.tscn"),
	MAPS.CornerTopLeft: preload("res://scenes/rooms/CornerTopLeft.tscn"),
	MAPS.CrossRoad: preload("res://scenes/rooms/CrossRoad.tscn"),
	MAPS.DeadEnd: preload("res://scenes/rooms/DeadEnd.tscn"),
	MAPS.LeftEnd: preload("res://scenes/rooms/LeftEnd.tscn"),
	MAPS.CrossRoadBot: preload("res://scenes/rooms/CrossRoadBot.tscn"),
	MAPS.LeftMiddle: preload("res://scenes/rooms/LeftMiddle.tscn"),
	MAPS.Map3Spawner: preload("res://scenes/rooms/Map3Spawner.tscn"),
	MAPS.RightEnd: preload("res://scenes/rooms/RightEnd.tscn"),
	MAPS.RightMiddle: preload("res://scenes/rooms/RightMiddle.tscn"),
	MAPS.ShopRoom: preload("res://scenes/rooms/ShopRoom.tscn"),
	MAPS.TopEnd: preload("res://scenes/rooms/TopEnd.tscn")
}

var currentRoomIdx = Vector2(1, 1)
var world = [
	[ MAPS.TopEnd, MAPS.CornerTopLeft, MAPS.RightEnd],
	[ MAPS.RightMiddle, MAPS.ShopRoom, MAPS.RightEnd],
	[ MAPS.CornerBotLeft, MAPS.CrossRoadBot, MAPS.RightEnd]
]

var PlayerTscn = preload("res://scenes/Avatar.tscn")

var bullerHolder = null
var player  = null
var currentRoom

func create_bullet_holder():
	if self.bullerHolder!= null:
		self.bullerHolder.queue_free()
	self.bullerHolder = Node2D.new()
	self.bullerHolder.set_name("BulletHolder")
	self.bullerHolder.set_as_toplevel(true)
	self.add_child(self.bullerHolder)

func _ready():
	self.restart()

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
	return self.world[pos.y][pos.x]

func move_to_room(room):
	create_bullet_holder()
	var tmp_room = self.currentRoom
	self.currentRoom = Maps[room].instance()
	if tmp_room != null :
		tmp_room.queue_free()
	self.currentRoom.add_to_group("map")
	self.add_child(self.currentRoom)
	self.currentRoom.set_z(self.currentRoom.get_z() - 10)
	

func change_room(pos, direction):
	var direction_vector = get_direction_vector(direction)
	self.currentRoomIdx += direction_vector
	var room = get_room(self.currentRoomIdx)
	self.move_to_room(room)
	
	self.player.set_pos(pos)
	self.player.set_z(self.currentRoom.get_z() + 2)

func restart():
	get_node("GameOver/Control/enemies_killed").set_text("0000")
	get_node("GameOver").hide()
	get_tree().set_pause(false)
	self.set_fixed_process(true)
	var cursorTexture = load("res://assets/target.png")
	
	self.currentRoomIdx = Vector2(1, 1)
	var room  = get_room(self.currentRoomIdx)
	self.move_to_room(room)
	
	self.player = PlayerTscn.instance()
	self.player.set_pos(Vector2(600, 400))
	self.player.add_to_group("player")
	self.add_child(player)
	self.player.set_z(self.currentRoom.get_z() + 2)
	
	get_node("HUD").init_life_bar()
	Input.set_custom_mouse_cursor(cursorTexture,cursorTexture.get_size()/2)
	
func death():
	self.player.queue_free()
	get_node("GameOver").show()
	get_node("GameOver").set_fixed_process(true)
	get_tree().set_pause(true)
	
func _fixed_process(delta):
	if self.player.dead and !self.player.get_node("AnimationPlayer").is_playing():
		self.death()
		
	var viewport_rect = get_viewport_rect()
	var new_pos = player.get_pos()
	var direction = null
	
	if player.get_pos().x < 0 :
		new_pos.x = viewport_rect.size.width - 64
		direction = "left"
	elif player.get_pos().x > viewport_rect.size.width :
		new_pos.x = 64
		direction = "right"
	elif player.get_pos().y < 0 :
		new_pos.y = viewport_rect.size.height - 64
		direction = "bottom"
	elif player.get_pos().y > viewport_rect.size.height :
		new_pos.y = 64
		direction = "up"
		
	if new_pos != player.get_pos():
		self.change_room(new_pos, direction)
