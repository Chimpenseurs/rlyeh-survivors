extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var direction = Vector2(1, 0)
var velocity = 200
var dist_range = 40

func _ready():
	print("bullet")
	set_fixed_process(true)

func init_bullet(velocity):
	self.set_linear_velocity(velocity)
	
func _fixed_process(delta):
	var motion = direction.normalized() * velocity * delta
	print(self.dist_range)
	self.dist_range -= direction.length()
	
	if self.dist_range <= 0:
		self.queue_free()