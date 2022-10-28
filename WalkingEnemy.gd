extends KinematicBody2D

var velocity = Vector2()

# Universal parameters
var gravity: int = 800

# General Behavior Type
var behavior: String = "walking"
var movement_speed
var direction = 1;
var grace = false
var graceTimer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.animation = "idle"
	$AnimatedSprite.play()

func getInput(delta):

	wallDetection(delta)
	velocity.x = movement_speed * direction
	
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
func _physics_process(delta):
	getInput(delta)

func wallDetection(delta):
	if (is_on_floor()):
		$AnimatedSprite.animation = "run"
		$AnimatedSprite.play()
		
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

# Used for basic creation of enemies
func generalBehavior(behaviorName):
	behavior = behaviorName
	if behavior == "walking":
		pass
		
func walkingParams():
	pass

func init(a, b):
	movement_speed = a
	gravity = b

func _on_Hitbox_area_entered(area):
	if (area.is_in_group("Player")):
		queue_free()
