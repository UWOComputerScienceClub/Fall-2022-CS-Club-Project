extends "res://Scenes/Objects/Enemies/Base/BasicEnemy.gd"

#------------#
# First Boss. #
#------------#

func _ready():
	
	gravity = 800
	movement_speed = 20
	direction = 1
	maxHealth = 5
	
	animationHandler("idle", true)
	
func _physics_process(delta):
	checkLastCollision(delta)
	surfaceDetection(delta)
	movementLogic(delta)

# Handles movement.
func movementLogic(delta):
	velocity.x = movement_speed * direction
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

# Handles parameters passed from enemySpawner.
func init(a, b):
	movement_speed = a
	gravity = b
