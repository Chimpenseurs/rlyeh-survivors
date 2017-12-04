extends Panel


func _ready():
	pass



func _on_Button_pressed():
	var weapons = get_node("ScrollContainer/weapon_list").get_children()
	var weapons_bought = []
	for w in weapons :
		if w.get_type() == "HBoxContainer" :
			if w.get_node("checkbox").is_pressed():
				weapons_bought.append(w.get_node("descr/weapon_name").get_text())
	
	print(weapons_bought)
