extends KinematicBody2D

var bulletTscn = preload("res://scenes/Bullet.tscn")

const shoot_speed = 500
const fire_rate = 0.2 # lets say in ms
const velocity = 350

var bullet_range = 100000
var damage = 50
var fire_ready = 0

func _ready():
	set_process_input(true)
	set_fixed_process(true)

func _fixed_process(delta):
	
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
		_shoot_arrow(delta)

func _shoot_arrow(delta):
	if self.fire_ready == 0:
		self.fire_ready = fire_rate
		var bullet_motion = (get_global_mouse_pos() - self.get_global_pos()).normalized() * shoot_speed
		var new_arrow = bulletTscn.instance()
		var arrow_rotation = get_angle_to(get_global_mouse_pos()) + self.get_rot()
		new_arrow.set_rot(arrow_rotation)
		new_arrow.set_global_pos(self.get_global_pos())
		get_parent().get_node("BulletHolder").add_child(new_arrow)
		new_arrow.init_bullet(bullet_motion, self.damage, self.bullet_range )

func take_damage(collider_pos):
	var direction = get_pos() - collider_pos
	
	self.move(direction)
	
	get_node("AnimationPlayer").play("take_damage")
