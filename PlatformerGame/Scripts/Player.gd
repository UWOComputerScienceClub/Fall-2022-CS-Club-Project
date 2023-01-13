extends KinematicBody2D

signal ded

export var speed = 200;
export var jumpForce = 600;
export var gravity = 800;

var snowball = preload("res://Scenes/Objects/Snowball.tscn");
var head = preload("res://Scenes/Objects/Head.tscn");

var velocity = Vector2();
var direction = Vector2.ZERO;

var grounded = false;
var isRoll = false;

var snowballDirection = 50;
var snowballRotation = 0;

func _ready():
	$snowLevel.value = $snowLevel.max_value;
	
	$AnimatedSprite.play();

func _physics_process(delta):
	if Input.is_action_pressed("roll") and $dashDowntime.is_stopped():
		if direction == Vector2(-1, 0): velocity.x -= speed * 3;
		else: velocity.x += speed * 3;
		$dashDowntime.start();
		$dashTimer.start();
	elif $dashTimer.is_stopped():
		velocity.x = 0;
		
		if Input.is_action_pressed("jump") and is_on_floor():
			$AnimatedSprite.animation = "jumping";
			velocity.y -= jumpForce;
		elif Input.is_action_pressed("shoot") and $snowballTimer.is_stopped() and $snowLevel.value > 10:
			$snowLevel.value -= 10;
			$snowballTimer.start();
			var s = snowball.instance();
			s.start(Vector2(position.x + snowballDirection, position.y), snowballRotation);
			get_parent().add_child(s);
		elif Input.is_action_pressed("head") and $snowballTimer.is_stopped() and $snowLevel.value > 25:
			$snowLevel.value -= 25;
			$snowballTimer.start();
			var h = head.instance();
			h.start(Vector2(position.x + snowballDirection, position.y), snowballRotation);
			get_parent().add_child(h);
			
		if Input.is_action_pressed("left"):
			velocity.x -= speed; direction = Vector2(-1,0);
			snowballDirection = -50; snowballRotation = PI;
			$AnimatedSprite.animation = "running";
			$AnimatedSprite.flip_h = true;
			if is_on_floor(): $snowLevel.value += .25;
		if Input.is_action_pressed("right"):
			velocity.x += speed; direction = Vector2(1,0);
			snowballDirection = 50; snowballRotation = 0;
			$AnimatedSprite.animation = "running";
			$AnimatedSprite.flip_h = false;
			if is_on_floor(): $snowLevel.value += .25;
		if !Input.is_action_pressed("left") && !Input.is_action_pressed("right"):
			$AnimatedSprite.animation = "standing";
		
	velocity.y += gravity * delta;
		
	velocity = move_and_slide(velocity, Vector2.UP);

func _on_Hitbox_body_entered(body):
	if (body.name).substr(1, 12) == "WalkingEnemy" or body.name == "WalkingEnemy":
		get_tree().reload_current_scene();
