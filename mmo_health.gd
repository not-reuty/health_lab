extends PanelContainer

signal mmo_health_changed
# link the player's health_changed signal to the update_health
func _ready():
	var player = get_node('/root/world/player')
	player.connect('health_changed', self, 'update_health')
	player.connect('overheal_changed', self, 'update_overheal')
	self.set('show_behind_parent', true)
	
func update_health(value):
	$health_bar.value = value
	emit_signal("mmo_health_changed", value)

func update_overheal(health, overheal):
	 # if the regeneration effect has ended
	if health >= overheal:
		$overheal_bar.value = 0
		$overheal_bar.visible = false
	else:
		$overheal_bar.visible = true
		$overheal_bar.value = overheal
