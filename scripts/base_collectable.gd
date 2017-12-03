extends Area2D

func _ready():
	pass

func _on_Hearth_body_enter( body ):
	if body.is_in_group("player"):
		body.devil_hearts += 1
		self.queue_free()
