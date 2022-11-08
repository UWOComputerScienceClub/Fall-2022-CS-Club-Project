extends "res://Scenes/Objects/Enemies/Base/BasicEnemy.gd"

#------------#
# Le Goomba. #
#------------#
var slope
var wallTimer = 0
var firstFrame = true
var jump

var friction
var maxVelocity
var maximum_speed

var playerPos
var directionNormal

onready var mainScene = get_node("/root").get_tree().get_current_scene().get_name()

func _ready():
	
	# Variables inherited from base
	
	gravity = 800
	
	jumpPower = 400
	
	movement_speed = 10
	maximum_speed = 600
	
	direction = -1
	maxHealth = 5
	friction = 20
	
	hurt = false
	dead = false
	hurtTicks = 5
	deathTicks = 6
	hurtMultiplier = 1
	timer = 0
	
	firstFrame = false

func _physics_process(delta):
	movementLogic(delta)
	animationBehavior(delta)
	hurtBehavior()
	deathBehavior()
	
	applyFriction(friction)

# Handles movement.
func movementLogic(delta):
	
	playerPos = get_node("/root/" + str(mainScene) + "/Player").position
	directionNormal = (playerPos - position).normalized()
	
	velocity.x += directionNormal.x * movement_speed
	velocity.x = clamp(velocity.x, -maximum_speed, maximum_speed)
	
	# Jumping logic; only jumps when in contact with a wall.
	if (is_on_wall()):
		velocity.x = 0
		jump = true

	if (jump):
		if (is_on_floor()):
			velocity.x += directionNormal.x * movement_speed
			velocity.y -= jumpPower
		jump = false
	
	#velocity.x += 1
	velocity.y += gravity * delta;
	
	velocity = move_and_slide(velocity, Vector2.UP);

func animationBehavior(delta):
	if (is_on_floor()):
		if (!hurt):
			animationHandler("run", "play")

	if (directionNormal.x > 0):
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true

# Handles parameters passed from enemySpawner.
func init(a, b):
	movement_speed = a
	gravity = b

func applyFriction(amount):
	if (sign(directionNormal.x) != sign(velocity.x)):
		var frict = (velocity.x / amount)
		velocity.x += directionNormal.x * (abs(frict) + 1)
