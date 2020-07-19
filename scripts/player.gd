extends Area2D

var max_health = 100.0
var health = max_health
var regen_per_second = 0
var degen_per_second = 0

onready var damage_text = load("res://scenes/damage_text.tscn")

signal health_changed
signal overheal_changed
signal overheal_ended

# energy drink variables, including applying the buff and the buff itself
var is_drinking_energy_drink = false
var energy_drinking_time = 2 # takes 2 seconds to drink an energy drink
var energy_drinking_time_remaining = 0
var energy_drink_regen_effect = 5 # heal
var energy_drink_regen_duration = 5
var energy_drink_effect_remaining = 0 # in seconds
var plus_effect_timer = 1

# painkillers apply the same regen as the energy drink but for longer
var is_taking_painkillers = false
var painkiller_taking_time = 5
var painkiller_taking_time_remaining = 0
var painkiller_effect_duration = 10

# bandages apply and instant heal after a few seconds of use
var is_using_bandage = false
var bandage_use_time = 2
var bandage_time_remaining = 0

var is_using_medkit = false
var medkit_use_time = 5
var medkit_time_remaining = 0

func _process(delta):
	
	var starting_health = health
	var starting_overheal = energy_drink_effect_remaining
	
	if regen_per_second > 0:
		health += regen_per_second * delta
	if degen_per_second > 0:
		health -= degen_per_second * delta

		
	
	if is_drinking_energy_drink:
		energy_drinking_time_remaining -= delta
		var drink_progress = (1 - (energy_drinking_time_remaining / energy_drinking_time)) * 100
		$drinking_progress.visible = true
		$drinking_progress.value = drink_progress
		if drink_progress >= 100: # player has finished drinking
			energy_drink_effect_remaining += energy_drink_regen_duration
			$drinking_progress.visible = false
			is_drinking_energy_drink = false
			
	if is_taking_painkillers:
		painkiller_taking_time_remaining -= delta
		var painkiller_progress = (1 - (painkiller_taking_time_remaining / painkiller_taking_time)) * 100
		$painkiller_progress.visible = true
		$painkiller_progress.value = painkiller_progress
		if painkiller_progress >= 100: # player has finished drinking
			energy_drink_effect_remaining += painkiller_effect_duration
			$painkiller_progress.visible = false
			is_taking_painkillers = false
	
	if energy_drink_effect_remaining > 0:
		health += energy_drink_regen_effect * delta
		energy_drink_effect_remaining -= delta
		var overheal = health + energy_drink_effect_remaining * energy_drink_regen_effect
		emit_signal("overheal_changed", health, overheal)
		
		plus_effect_timer += delta
		if plus_effect_timer > 0.5:
			plus_effect_timer = 0
			var text = damage_text.instance()
			text.text = '+'
			text.get_font("font").set_outline_color(Color(0, 0.6, 0, 1))
			add_child(text)
	
	# bandage and medkit section
	if is_using_bandage:
		bandage_time_remaining -= delta
		var bandage_progress = (1 - (bandage_time_remaining / bandage_use_time)) * 100
		$bandage_progress.visible = true
		$bandage_progress.value = bandage_progress
		if bandage_progress >= 100: # player has finished drinking
			$bandage_progress.visible = false
			is_using_bandage = false
			_on_flash_heal_pressed()
			
	if is_using_medkit:
		medkit_time_remaining -= delta
		var medkit_progress = (1 - (medkit_time_remaining / medkit_use_time)) * 100
		$medkit_progress.visible = true
		$medkit_progress.value = medkit_progress
		if medkit_progress >= 100: # player has finished drinking
			$medkit_progress.visible = false
			is_using_medkit = false
			_on_lay_on_hands_pressed()
	
	if health != starting_health:
		emit_signal("health_changed", health)
	
	health = clamp(health, 0, max_health)


func take_damage(value):
	health -= min(health, value)
	emit_signal("health_changed", health)
	
	var text = damage_text.instance()
	text.text = '-' + str(value)
	text.get_font("font").set_outline_color(Color(0.6, 0, 0, 1))
	add_child(text)
	
	
	
# ==== UI FUNCTIONS ====
# the following functions only exist to change the values in the code using the UI,
# if you use this in a real project you can delete all of these and instead link them
# to the player's inventory (with the bandages and things inside)



func _on_punch_pressed():
	take_damage(10.0)
	print('player punched, lost 10 health')


func _on_whack_pressed():
	var health_to_lose = int(health - 5)
	take_damage(health_to_lose)
	print('player punched, lost 10 health')


func _on_regen_scrollbar_value_changed(value):
	regen_per_second = value


func _on_energy_drink_pressed():
	if is_taking_painkillers:
		return
	is_drinking_energy_drink = true
	energy_drinking_time_remaining = energy_drinking_time


func _on_painkiller_pressed():
	if is_drinking_energy_drink:
		return
	is_taking_painkillers = true
	painkiller_taking_time_remaining = painkiller_taking_time


func _on_flash_heal_pressed():
	var heal_size = int(min(20, max_health - health + 0.4))
	health += heal_size
	emit_signal("health_changed", health)
	
	var text = damage_text.instance()
	text.text = '+' + str(heal_size)
	text.get_font("font").set_outline_color(Color(0, 0.8, 0, 1))
	add_child(text)


func _on_lay_on_hands_pressed():
	var heal_size = int(max_health - health + 0.4)
	health += heal_size
	emit_signal("health_changed", health)
	
	var text = damage_text.instance()
	text.text = '+' + str(heal_size)
	text.get_font("font").set_outline_color(Color(0, 0.8, 0, 1))
	add_child(text)


func _on_strength_value_changed(value):
	energy_drink_regen_effect = value

func _on_degen_scrollbar_value_changed(value):
	degen_per_second = value


func _on_bandage_pressed():
	is_using_bandage = true
	bandage_time_remaining = bandage_use_time

func _on_medkit_pressed():
	is_using_medkit = true
	medkit_time_remaining = medkit_use_time
