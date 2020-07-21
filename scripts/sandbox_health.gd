extends PanelContainer

onready var player = get_node('/root/world/player')
# link the player's health_changed signal to the update_health
func _ready():
	player.connect('health_changed', self, 'update_health')
	
func update_health(value):
	# width of image * number of hearts * hearts to show (to nearest 1/20th, or 0.05)
	var new_width = 73 * 10 * stepify(value / 100, 0.05)
	$hearts_sprite.region_rect = Rect2(0,0,new_width, 64)
