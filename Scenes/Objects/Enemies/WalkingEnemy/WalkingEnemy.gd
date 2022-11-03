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

# Collision
var lastCollision

func _ready():
	$AnimatedSprite.animation = "idle"
	$AnimatedSprite.play()
	
func _physics_process(delta):
	processMovement(delta)

func processMovement(delta):
	
	var collision = move_and_collide(velocity * delta)
	if collision: 
		lastCollision = collision.collider.name
	
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
	if (is_on_wall() && lastCollision != "KinematicBody2D"):
		direction *= -1
		$AnimatedSprite.flip_h = !($AnimatedSprite.flip_h)

# Handles parameters passed from enemySpawner.
func init(a, b):
	movement_speed = a
	gravity = b
