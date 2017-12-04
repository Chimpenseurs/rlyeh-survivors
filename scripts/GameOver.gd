extends Node2D

var game 

func _ready():
	self.game = self.get_parent() # should be the game
	
func _fixed_process(delta):
	if Input.is_action_pressed("action_restart"):
		self.set_fixed_process(false)
		self.game.restart()
	