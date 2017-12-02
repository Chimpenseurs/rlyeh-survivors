extends Area2D

func _ready():
	pass

func _fixed_process(delta):
 process_stuff()

func _on_Hearth_body_enter( body ):
	if body.is_in_group("player"):
		self.queue_free()
