extends Area2D

"""
EnemyHitbox.gd

Controls enemy health, collisions.

"""

# Health parameters
var maxHealth = 2
var health = 0
var regen = 1

func _ready():
	health = maxHealth
	pass # Replace with function body.

func _on_EnemyHitbox_area_entered(area):
	if (area.is_in_group("Player")):
		get_parent().queue_free()
	elif (area.is_in_group("Snowball")):
		health -= 1
		updateHealthBar()
		if (health <= 0):
			get_parent().queue_free()
		area.get_parent().queue_free()

func updateHealthBar():
	get_node("HealthBar").updateBar()
