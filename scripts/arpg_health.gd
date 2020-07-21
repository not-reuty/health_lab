extends PanelContainer


# link the player's health_changed signal to the update_health
func _ready():
	var player = get_node('/root/world/player')
	player.connect('health_changed', self, 'update_health')
	player.connect('overheal_changed', self, 'update_overheal')
	
func update_health(value):
	$health_bowl.value = value

func update_overheal(health, overheal):
	 # if the regeneration effect has ended
	if health >= overheal:
		$overheal_bowl.value = 0
		$overheal_bowl.visible = false
	else:
		$overheal_bowl.visible = true
		$overheal_bowl.value = overheal
