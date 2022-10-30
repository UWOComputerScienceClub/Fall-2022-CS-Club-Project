extends KinematicBody2D

#--------------------------------------------------------------------------------------------------#
# "Flying Enemy"
#
# A basic sin-wave enemy. Flips when it hits a wall. No flight path.
#--------------------------------------------------------------------------------------------------#

var frequency = 5
var amplitude = 200
var movement = 0
var time = 0


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
	$AnimatedSprite.animation = "fly"
	$AnimatedSprite.play()

func _physics_process(delta):
	time += delta 
	#movement = cos(time*frequency)*amplitude
	#position.x += movement * delta
	
	position.y += cos(time * frequency) * amplitude * delta
	position.x += 2 * direction
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	processMovement(delta)

func processMovement(delta):
	surfaceDetection(delta)


func surfaceDetection(delta):
	
	# Changes animation if touching floor
	if (is_on_floor()):
		$AnimatedSprite.animation = "fly"
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
