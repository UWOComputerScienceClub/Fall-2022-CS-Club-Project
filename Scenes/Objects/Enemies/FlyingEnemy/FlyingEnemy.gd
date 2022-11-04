extends "res://Scenes/Objects/Enemies/Base/BasicEnemy.gd"

#------------#
# Le Goomba. #
#------------#

var time = 0
var rng = RandomNumberGenerator.new()
var amplitude
var frequency

func _ready():
	rng.randomize()
	gravity = 8
	movement_speed = 200
	direction = 1
	maxHealth = 3
	amplitude = 6
	frequency = 11
	health = maxHealth
	animationHandler("idle", true)
	
func _physics_process(delta):
	checkLastCollision(delta)
	surfaceDetection(delta)
	movementLogic(delta)

# Handles movement.
func movementLogic(delta):
	time += delta
	velocity.x = movement_speed * direction
	position.y += amplitude * sin (time * frequency)
	
	#velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

# Handles parameters passed from enemySpawner.
func init(a, b):
	movement_speed = a
	gravity = b
