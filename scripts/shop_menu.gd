extends Panel


func _ready():
	pass

func update_store(hearts, eyes, shoes, enabled_weapons) :
	var weapons = get_node("ScrollContainer/weapon_list").get_children()
	for w in weapons :
		if w.get_type() == "HBoxContainer" :
			if enabled_weapons.has(w.get_node("descr/weapon_name").get_text()) :
				w.hide()
			else :
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
				weapons_bought.append({
						"name": w.get_node("descr/weapon_name").get_text(),
						"heart_malus": int(w.get_node("weapon_cost/hearts_cost/Label").get_text()),
						"eye_malus": int(w.get_node("weapon_cost/eyes_cost/Label").get_text()),
						"shoe_malus": int(w.get_node("weapon_cost/shoes_cost/Label").get_text())
					})
				w.get_node("checkbox").set_pressed(false)
				w.hide()
	
	if weapons_bought.size() > 0 :
		var player = get_tree().get_nodes_in_group("player")[0]
		player.add_weapons(weapons_bought)
