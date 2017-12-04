extends StaticBody2D


func _ready():
	var list = get_node("shop_menu")
	list.hide()

func _on_Area2D_body_enter( body ):
	if(body.is_in_group("player")):
		var list = get_node("shop_menu")
		list.show()


func _on_Area2D_body_exit( body ):
	if(body.is_in_group("player")):
		var list = get_node("shop_menu")
		list.hide()

