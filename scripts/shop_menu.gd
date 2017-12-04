extends Panel


func _ready():
	pass

func update_store(hearts, eyes, shoes) :
	var weapons = get_node("ScrollContainer/weapon_list").get_children()
	for w in weapons :
		if w.get_type() == "HBoxContainer" :
			var checkbox = w.get_node("checkbox")
			checkbox.set_disabled(false)
			
			var cost = w.get_node("weapon_cost/hearts_cost/Label")
			cost.add_color_override("font_color", Color("#FFFFFF"))
			if hearts < int(cost.get_text()) :
				cost.add_color_override("font_color", Color("#ef1f1f"))
				checkbox.set_disabled(true)
			
			cost = w.get_node("weapon_cost/eyes_cost/Label")
			cost.add_color_override("font_color", Color("#FFFFFF"))
			if eyes < int(cost.get_text()) :
				cost.add_color_override("font_color", Color("#ef1f1f"))
				checkbox.set_disabled(true)
			
			cost = w.get_node("weapon_cost/shoes_cost/Label")
			cost.add_color_override("font_color", Color("#FFFFFF"))
			if shoes < int(cost.get_text()) :
				cost.add_color_override("font_color", Color("#ef1f1f"))
				checkbox.set_disabled(true)
			

func _on_Button_pressed():
	var weapons = get_node("ScrollContainer/weapon_list").get_children()
	var weapons_bought = []
	for w in weapons :
		if w.get_type() == "HBoxContainer" :
			if w.get_node("checkbox").is_pressed():
				weapons_bought.append(w.get_node("descr/weapon_name").get_text())
	
	print(weapons_bought)
