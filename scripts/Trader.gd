extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	var list = get_node("ShopListWrapper")
	list.hide()
	pass

func _fixed_process(delta):
	pass

func _on_Area2D_body_enter( body ):
	var list = get_node("ShopListWrapper")
	if(body.is_in_group("player")):
		print("enter the area")
		list.show()
	pass # replace with function body


func _on_Area2D_body_exit( body ):
	var list = get_node("ShopListWrapper")
	if(body.is_in_group("player")):
		list.hide()
	pass # replace with function body


func _on_ShopListWrapper_item_activated( index ):
	print("bought!!")
	pass # replace with function body


func _on_Button_pressed():
	print("pressed")
	pass # replace with function body
