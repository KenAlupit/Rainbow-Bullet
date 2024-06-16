extends Panel

func set_unlocked(g_name, value):
	print(g_name)
	var equip = $Guns.get_node(g_name)
	
	if (equip):
		equip.unlocked = value

func set_equipped(g_name, value):
	var equip = $Guns.get_node(g_name)
	
	if (equip):
		equip.equipped = value
		
