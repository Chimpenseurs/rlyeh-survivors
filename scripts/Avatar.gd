extends KinematicBody2D

# class member variables go here, for example:
const velocity = 200

func _ready():
	set_process_input(true)
	set_fixed_process(true)

func _fixed_process(delta):
	var vect = Vector2(0,0)
	if Input.is_action_pressed("ui_up") :
		vect.y = -1
	elif Input.is_action_pressed("ui_down") :
		vect.y = 1
	
	if Input.is_action_pressed("ui_right") :
		vect.x = 1
	elif Input.is_action_pressed("ui_left") :
		vect.x = -1
	
	self.move(vect.normalized() * velocity * delta)
		
