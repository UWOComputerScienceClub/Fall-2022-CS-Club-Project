extends "res://Scenes/Objects/Enemies/Base/BasicEnemy.gd"

#
# Walking Enemy
#
# Le Goomba. Walks in one direction, flips direction after hitting a wall.
#

func _ready():
	
	gravity = 800
	movement_speed = 200
	direction = 1
	maxHealth = 5

	hurt = false
	dead = false
	hurtTicks = 5
	deathTicks = 6
	hurtMultiplier = 1
	timer = 0
	
	animationHandler("idle", "play")

func _physics_process(delta):
	movementLogic(delta)
	animationBehavior(delta)
	hurtBehavior()
	deathBehavior()

# How does the enemy move?
func movementLogic(delta):
	velocity.x = movement_speed * direction * hurtMultiplier
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

# How is the enemy animated?
func animationBehavior(delta):
	# Check for floor
	if (is_on_floor()):
		if (!hurt):
			animationHandler("run", "play")
	# Check for walls
	if (is_on_wall()):
		if (lastKinematic2DCollision(delta) != "KinematicBody2D"):
			direction *= -1
			$AnimatedSprite.flip_h = !($AnimatedSprite.flip_h)

# What parameters can be passed to the enemy?
func init(a, b):
	movement_speed = a
	gravity = b
