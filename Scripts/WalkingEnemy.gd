extends KinematicBody2D

#--------------------------------------------------------------------------------------------------#
# "Walking Enemy"
#
# Your standard, goomba-like enemy. Walks in one direction horizontally, flips when it hits a wall.
#--------------------------------------------------------------------------------------------------#

var velocity = Vector2()

# Universal parameters
var gravity: int = 800

# General Behavior Type
var movement_speed = 50
var direction = 1

# Health parameters
var health = 2
var regen = 0

# Timer
var grace = false
var graceTimer = 0

func _ready():
	$AnimatedSprite.animation = "idle"
	$AnimatedSprite.play()
	
func _physics_process(delta):
	processMovement(delta)

func processMovement(delta):
	surfaceDetection(delta)
	
	velocity.x = movement_speed * direction
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)


func surfaceDetection(delta):
	
	# Changes animation if touching floor
	if (is_on_floor()):
		$AnimatedSprite.animation = "run"
		$AnimatedSprite.play()
	
	# Flips direction if hitting a wall
	# (Grace: frame window that prevents direction from rapidly switching)
	if (!grace):
		if (is_on_wall()):
			direction *= -1
			$AnimatedSprite.flip_h = !($AnimatedSprite.flip_h)
			grace = true
	else:
		graceTimer += delta * 60
		if (graceTimer > delta * 60):
			grace = false
			graceTimer = 0

# Handles parameters passed from enemySpawner.
func init(a, b):
	movement_speed = a
	gravity = b

# Handles collision from player
func _on_Hitbox_area_entered(area):
	if (area.is_in_group("Player")):
		queue_free()
	elif (area.is_in_group("Snowball")):
		health -= 1
		if (health <= 0):
			queue_free()
		area.get_parent().queue_free()
