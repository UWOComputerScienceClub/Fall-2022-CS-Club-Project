extends KinematicBody2D

# ------------------------------- # ---------------------------------------------------------------
# Inherited by all basic enemies. #
# ------------------------------- #

var velocity = Vector2()

# Universal parameters
var gravity: int = 800

# Timers
var timer

# General Behavior
var movement_speed = 50
var jumpPower = 0
var direction = 1 # Linear, used for walking enemies

# Health
var health = 0
var maxHealth = 100
var regen = 0

# Damage States
var hurt = false
var hurtTicks = 20
var hurtMultiplier = 1

var dead = false
var deathTicks = 20
# Collision checks
var lastCollision

# -------------------------------------------------------------------------------------------------
# Common Behaviors

func hurtBehavior():
	if (hurt):
		if (timer < hurtTicks):
			hurtMultiplier = 0.5
			modulate = Color(1, 1, 1, 0.4)
			timer += 1
		else:
			timer = 0
			modulate = Color(1, 1, 1)
			hurtMultiplier = 1
			hurt = false

func deathBehavior():
	if (dead):
		if (timer < deathTicks):
			hurtMultiplier = 0
			animationHandler("idle", "play")
			modulate = Color(1, 0, 1, 0.5)
			timer += 1
		else:
			timer = 0
			queue_free()

# -------------------------------------------------------------------------------------------------

func lastKinematic2DCollision(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		 return collision.collider.name

# Stores last Kinematic2D Collision
func checkLastCollision(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		lastCollision = collision.collider.name

# Handles animation setup and playback for enemies.
func animationHandler(anim, play: String):
	$AnimatedSprite.animation = anim
	if (play == "play"):
		$AnimatedSprite.play()
	elif (play == "stop"):
		$AnimatedSprite.stop()
