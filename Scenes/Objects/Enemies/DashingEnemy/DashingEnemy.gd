extends "res://Scenes/Objects/Enemies/Base/BasicEnemy.gd"

#------------#
# Le Goomba. #
#------------#
var slope
var timer = 0
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
	
	gravity = 800
	
	jumpPower = 300
	
	movement_speed = 2
	maximum_speed = 200
	
	direction = -1
	maxHealth = 5
	friction = 20
	
	firstFrame = false

func _physics_process(delta):
	
	if (hurt):
		velocity.x = 0
		print("ouch!")
		animationHandler("hurt", true)
		hurt = false
	elif (is_on_floor()):
		animationHandler("run", true)

	checkLastCollision(delta)
	movementLogic(delta)
	orientEnemy()
	
	applyFriction(friction)
	
	# Apply friction only when facing a direction but moving away from it
#	if (sign(direction.x) != sign(velocity.x)):
#		friction = (velocity.x / 20)
#	else:
#		friction = 1

func getDirection():
	playerPos = get_node("/root/" + str(mainScene) + "/Player").position
	directionNormal = (playerPos - position).normalized()

func orientEnemy():
	if (directionNormal.x > 0):
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
	





# Handles movement.
func movementLogic(delta):
	
	getDirection()
	orientEnemy()
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

# Handles parameters passed from enemySpawner.
func init(a, b):
	movement_speed = a
	gravity = b

func applyFriction(amount):
	if (sign(directionNormal.x) != sign(velocity.x)):
		var frict = (velocity.x / amount)
		velocity.x += directionNormal.x * (abs(frict) + 1)
