extends HScrollBar


func _on_regen_scrollbar_value_changed(value):
	get_node('../../regen_title').text = 'Regeneration: ' + str(value)
