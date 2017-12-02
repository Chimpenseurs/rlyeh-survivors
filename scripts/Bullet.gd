extends RigidBody2D

# set at one so it won't be killed in the first call to _fixed_process
var dist_range = 100
var motion = Vector2(0, 0)
var damages = 0

func _ready():
	set_fixed_process(true)
	self.set_gravity_scale(0)

func init_bullet(velocity, damages, dist_range):
	self.motion = velocity
	self.damages = damages
	self.dist_range = dist_range
	self.set_linear_velocity(self.motion)

func _fixed_process(delta):
	if self.dist_range <= 0:
		self.queue_free()
	self.dist_range -= motion.length()

func _on_Bullet_body_enter( body ):
	if body.is_in_group("enemy"):
		body.take_damage(self.damages)
		self.queue_free()

	elif !body.is_in_group("player"):
		self.queue_free()