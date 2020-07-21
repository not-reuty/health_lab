extends Label

var value = int(self.text)

signal value_changed

func change_value(amount):
	value += amount
	value = clamp(value, 0, 10)
	self.text = str(value)
	emit_signal("value_changed", value)

func _on_nerf_consumable_pressed():
	change_value(-1)

func _on_buff_consumable_pressed():
	change_value(1)
