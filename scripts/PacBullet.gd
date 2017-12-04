extends "Bullet.gd"

func _ready():
	get_node("AnimationPlayer").play("idle")
	pass

func init_bullet(velocity, damages, dist_range):
	self.motion = velocity
	self.damages = 100
	self.dist_range = 100000
	self.pierce = 3
	
	var arrow_rotation = get_angle_to(get_global_mouse_pos() ) - 90# self.get_rot()
	self.set_rot(arrow_rotation)

	self.set_linear_velocity(self.motion)