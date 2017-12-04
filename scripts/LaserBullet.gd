extends "Bullet.gd"

func _ready():
	set_fixed_process(true)
	self.set_gravity_scale(0)

func init_bullet(velocity, damages, dist_range):
	self.motion = velocity
	self.damages = damages
	self.dist_range = 500

	
	var arrow_rotation = get_angle_to(get_global_mouse_pos()) - self.get_rot()
	self.set_rot(-arrow_rotation)

	self.set_linear_velocity(self.motion)


func _fixed_process(delta):
	if self.dist_range <= 0:
		self.queue_free()
	self.dist_range -= motion.length()