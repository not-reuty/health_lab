extends HScrollBar

func _on_degen_scrollbar_value_changed(value):
	get_node('../../degen_title').text = 'damage over time: ' + str(value)
	var children = get_children()
	
	if value == 0:
		children[0].visible = false
		children[1].visible = false
		children[2].visible = false
		children[3].visible = true
	else:
		children[0].visible = true
		children[1].visible = true
		children[2].visible = true
		children[3].visible = false
		# set the scales of the clouds independently for effect
		children[0].scale = Vector2(0.4 + value/30.0, 0.4 + value/30.0)
		children[1].scale = Vector2(0.3 + value/30.0, 0.3 + value/30.0)
		children[2].scale = Vector2(0.1 + value/30.0, 0.1 + value/30.0)
