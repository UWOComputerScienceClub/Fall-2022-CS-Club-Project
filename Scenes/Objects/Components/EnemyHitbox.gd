extends Area2D

#
# Controls enemy health, collisions.
#

# Health parameters, passed on from 
var maxHealth
var health
var regen

var firstTick = true

func _process(_delta):
	if (firstTick):
		# Grab health from enemy script
		maxHealth = get_parent().maxHealth
		health = get_parent().health
		regen = get_parent().regen
		health = maxHealth
		firstTick = false

# Collision reactions
func _on_EnemyHitbox_area_entered(area):
	if (area.is_in_group("Player")):
		get_parent().queue_free()
	elif (area.is_in_group("Snowball")):
		health -= 1
		get_parent().hurt = true
		updateHealthBar()
		if (health <= 0):
			get_parent().queue_free()
		area.get_parent().queue_free()

# Accesses HealthBar component to update health
func updateHealthBar():
	get_node("HealthBar").updateBar()
