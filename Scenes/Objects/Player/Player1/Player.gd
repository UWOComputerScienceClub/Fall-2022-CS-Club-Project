extends KinematicBody2D

export var speed = 200;
export var jumpForce = 600;
export var gravity = 800;

var snowball = preload("res://Scenes/Objects/Player/Player Projectiles/Snowball.tscn");

var velocity = Vector2();
var direction = Vector2.ZERO;

var grounded = false;
var numJumps = 2;
var isRoll = false;

var snowballDirection = 50;
var snowballRotation = 0;

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	velocity.x = 0;

	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y -= jumpForce;
	elif Input.is_action_pressed("shoot") and $snowballTimer.is_stopped():
		$snowballTimer.start();
		var s = snowball.instance();
		s.start(Vector2(position.x + snowballDirection, position.y), snowballRotation);
		get_parent().add_child(s)
		
	if Input.is_action_pressed("left"):
		velocity.x -= speed;
		direction = Vector2(-1,0);
		snowballDirection = -50;
		snowballRotation = PI;
	if Input.is_action_pressed("right"):
		velocity.x += speed;
		direction = Vector2(1,0);
		snowballDirection = 50;
		snowballRotation = 0;
	
	velocity.y += gravity * delta;
	
	velocity = move_and_slide(velocity, Vector2.UP);
