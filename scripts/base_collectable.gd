extends Area2D

func _ready():
	pass

func _on_Hearth_body_enter( body ):
	if body.is_in_group("player"):
		body.devil_hearts += 1
		self.queue_free()

func _on_Eye_body_enter( body ):
	if body.is_in_group("player"):
		body.devil_eyes += 1
		self.queue_free()

func _on_Shoe_body_enter( body ):
	if body.is_in_group("player"):
		body.devil_shoes += 1
		self.queue_free()