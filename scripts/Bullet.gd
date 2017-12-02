extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var direction = Vector2(1, 0)
var velocity = 200

func _ready():
	set_fixed_process(false)

func _fixed_process(delta):
	self.move(direction.normalized() * velocity * delta)
	