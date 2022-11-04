extends KinematicBody2D

# ------------------------------- #
#     Inherited by all bosses.    #
# ------------------------------- #

var velocity = Vector2()

# Universal parameters
var gravity: int = 800

# General Behavior Type
var movement_speed = 50
var direction = 1

# Health
var health = 0
var maxHealth = 100
var regen = 0

var lastCollision

# Handles surface detection behaviors.
func surfaceDetection(delta):
	
	if (is_on_floor()):
		animationHandler("run", true)
		
	if (is_on_wall() && lastCollision != "KinematicBody2D"):
		direction *= -1
		$AnimatedSprite.flip_h = !($AnimatedSprite.flip_h)

# Stores last Kinematic2D Collision
func checkLastCollision(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		lastCollision = collision.collider.name

# Handles animation setup and playback.
func animationHandler(anim, play):
	$AnimatedSprite.animation = anim
	if (play):
		$AnimatedSprite.play()
