extends KinematicBody2D

var weapons = {
	"pistol":{
		"fire_rate": 0.75,
		"damage": 50,
		"sprite": null,
		"fire": "_shoot_arrow_rifle",
		"bulletTscn" : preload("res://scenes/Bullet.tscn")
	},
	"laser gun":{
		"fire_rate": 0.2,
		"damage": 50,
		"sprite": null,
		"fire": "_shoot_arrow",
		"bulletTscn" : preload("res://scenes/LaserBullet.tscn")
	},
	"Paczooka":{
		"fire_rate": 0.85,
		"damage": 100,
		"sprite": null,
		"fire": "_shoot_arrow",
		"bulletTscn" : preload("res://scenes/PacBullet.tscn")
	},
	"Pump":{
		"fire_rate": 0.50,
		"damage": 100,
		"sprite": null,
		"fire": "_shoot_rifle",
		"bulletTscn" : preload("res://scenes/PacBullet.tscn")
	}
}

var enabled_weapons
var current_weapon_id
var current_weapon
const shoot_speed = 500
const bullet_range = 50000
var fire_ready = 0

var velocity

var dead

var max_life
var life

var devil_hearts
var devil_eyes
var devil_shoes

var timer = 0

func _ready():
	# Init weapon sprite
	weapons["pistol"]["sprite"]    = get_node("Sprite/pistol")
	weapons["laser gun"]["sprite"] = get_node("Sprite/laser gun")
	weapons["Paczooka"]["sprite"] = get_node("Sprite/Paczooka")
	weapons["Pump"]["sprite"] = get_node("Sprite/Pump")
	
	# Init vars
	dead = false
	max_life = 5000
	life = max_life
	
	enabled_weapons = ["pistol"]
	current_weapon_id = 0
	current_weapon = weapons[enabled_weapons[current_weapon_id]]
	
	velocity = 350
	
	devil_hearts = 0
	devil_eyes = 0
	devil_shoes = 0
	
	set_process_input(true)
	set_fixed_process(true)

func _input(event):
	if event.is_action_pressed("next_weapon") :
		current_weapon["sprite"].hide()
		current_weapon_id += 1
		if current_weapon_id > enabled_weapons.size() - 1 :
			current_weapon_id = 0
		current_weapon = weapons[enabled_weapons[current_weapon_id]]
		current_weapon["sprite"].show()
	elif event.is_action_pressed("previous_weapon") :
		current_weapon["sprite"].hide()
		current_weapon_id -= 1
		if current_weapon_id < 0 :
			current_weapon_id = enabled_weapons.size() - 1
		current_weapon = weapons[enabled_weapons[current_weapon_id]]
		current_weapon["sprite"].show()

func _fixed_process(delta):
	
	timer += delta
	if (timer > 5 &&  self.life < self.max_life):
		self.life +=1
		
	set_player_orientation()
	self.fire_ready -= delta
	if self.fire_ready < 0:
		self.fire_ready = 0
	
	var vect = Vector2(0,0)
	
	if Input.is_action_pressed("ui_up") :
		vect.y = -1
	if Input.is_action_pressed("ui_down") :
		vect.y = 1
	if Input.is_action_pressed("ui_right") :
		vect.x = 1
	if Input.is_action_pressed("ui_left") :
		vect.x = -1
	
	var motion = vect.normalized() * velocity * delta
	self.move(motion)
	
	if is_colliding() :
		var n = get_collision_normal()
		motion = n.slide(motion)
		vect = n.slide(vect)
		move(motion)
		
	if Input.is_action_pressed("action_shoot"):
		self.call(current_weapon["fire"])

func _shoot_rifle():
	var shoot_position = current_weapon["sprite"].get_node("ShotPosition")
	var cone = 0.1
	var mouse_pos = get_global_mouse_pos()
	var shoot_pos = shoot_position.get_global_pos()
	var sep_dist = mouse_pos.distance_to(shoot_pos)

	if self.fire_ready == 0:
		self.fire_ready = self.current_weapon["fire_rate"]
		get_node("SamplePlayer").play("laser")

		for i in range(-3, 3):
			self.fire_ready = self.current_weapon["fire_rate"]
			# We get a point at a distance of 1 on the line defined by the shoot pos to the mouse
			# then we apply a rotation
			# https://math.stackexchange.com/questions/175896/finding-a-point-along-a-line-a-certain-distance-away-from-another-point
			var new_arrow = self.current_weapon["bulletTscn"].instance()
			var bullet_motion = (mouse_pos - shoot_pos)
			var shift_pos = shoot_pos + bullet_motion.normalized()
			var bullet_motion_f = (shift_pos - shoot_pos).rotated(cone*i)
			
			# shift_pos 
			new_arrow.set_max_contacts_reported(100)
			new_arrow.set_global_pos(shoot_position.get_global_pos())
			get_parent().bullerHolder.add_child(new_arrow)
			get_node("SamplePlayer").play("laser")
			new_arrow.init_bullet(bullet_motion_f.normalized()*shoot_speed, self.current_weapon["damage"], self.bullet_range )
		
func _shoot_arrow():
	if self.fire_ready == 0:
		self.fire_ready = self.current_weapon["fire_rate"]
		var shoot_position = current_weapon["sprite"].get_node("ShotPosition")
		
		var bullet_motion = (get_global_mouse_pos() - shoot_position.get_global_pos()).normalized() * shoot_speed
		var new_arrow = self.current_weapon["bulletTscn"].instance()

		new_arrow.set_global_pos(shoot_position.get_global_pos())
		get_parent().bullerHolder.add_child(new_arrow)
		get_node("SamplePlayer").play("laser")
		new_arrow.init_bullet(bullet_motion, self.current_weapon["damage"], self.bullet_range )

func set_player_orientation():
	var self_pos = self.get_pos()
	var mouse_pos = self.get_global_mouse_pos()
	var dif = self_pos - mouse_pos
	if dif.x > 0:
		self.set_scale(Vector2(-1, 1))
		self.current_weapon["sprite"].set_z(1)
	else :
		self.set_scale(Vector2(1, 1))
		self.current_weapon["sprite"].set_z(-1)
	
func take_damage(collider_pos, damage_amount):
	var direction = get_pos() - collider_pos
	life -= damage_amount
	
	if self.life <= 0 and !self.dead:
		self.dead = true
		self.play_animation("death")
		return
		
	if life > 0:
		self.move(direction.normalized() * 50)
		get_node("SamplePlayer").play("takeDamage")
		play_animation("take_damage")

func add_weapons(weapons_bought) :
	for w in weapons_bought :
		enabled_weapons.append(w["name"])
		
		max_life *= (100.0 - float(w["heart_malus"])) / 100.0
		if life > max_life :
			life = max_life
		
		devil_hearts -= w["heart_malus"]
		
		# TODO : Precision
		devil_eyes -= w["eye_malus"]
		
		velocity *= (100.0 - float(w["shoe_malus"])) / 100.0
		devil_shoes -= w["shoe_malus"]
	
	# Equip last weapon
	current_weapon["sprite"].hide()
	current_weapon = weapons[enabled_weapons.back()]
	current_weapon["sprite"].show()
	

# Helper to play animation
func play_animation(animation):
	self.get_node("AnimationPlayer").play(animation)
