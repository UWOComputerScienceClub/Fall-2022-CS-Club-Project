extends "res://Scenes/Objects/Enemies/Base/BasicEnemy.gd"

#------------#
# Le Goomba. #
#------------#

var time = 0
var rng = RandomNumberGenerator.new()
var amplitude
var frequency

func _ready():
	gravity = 8
	movement_speed = 200
	direction = 1
	
	hurt = false
	dead = false
	hurtTicks = 5
	deathTicks = 6
	hurtMultiplier = 1
	timer = 0
	
	rng.randomize()
	maxHealth = 3
	amplitude = 6
	frequency = 11
	
	health = maxHealth
	animationHandler("idle", "play")
	
func _physics_process(delta):
	movementLogic(delta)
	animationBehavior(delta)
	hurtBehavior()
	deathBehavior()

# Handles movement.
func movementLogic(delta):
	time += delta
	velocity.x = movement_speed * direction * hurtMultiplier
	position.y += amplitude * sin (time * frequency)
	
	#velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func animationBehavior(delta):

	if (is_on_floor()):
		if (!hurt):
			animationHandler("run", "play")

	if (is_on_wall()):
		if (lastKinematic2DCollision(delta) != "KinematicBody2D"):
			direction *= -1
			$AnimatedSprite.flip_h = !($AnimatedSprite.flip_h)

# Handles parameters passed from enemySpawner.
func init(a, b):
	movement_speed = a
	gravity = b
