extends Label

# this is somewhat of a workaround to let me position the text exactly where I want it,
# another way is to have the label as a child of the mmo_health panel container but
# that can be more restrictive

func _on_mmo_health_mmo_health_changed(value):
	self.text = str(int(value)) + '/100'
