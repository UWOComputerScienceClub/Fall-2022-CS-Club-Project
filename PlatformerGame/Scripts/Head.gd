extends KinematicBody2D

onready var player = get_node("/root/MainScene/Player")

signal landed

export var speed = 750;
export var jumpForce = 600;
export var gravity = 800;
export var weight = 5;

var velocity = Vector2();

func start(pos, dir):
	rotation = dir;
	position = pos;
	velocity = Vector2(speed, 0).rotated(rotation);
	velocity.y -= jumpForce;

func _physics_process(delta):
	velocity.y += weight * gravity * delta;
	
	if (is_on_floor() || is_on_wall()): # Added
		player.position.x = position.x;
		queue_free();
	
	velocity = move_and_slide(velocity, Vector2.UP) # Added

func _on_VisibilityNotifier2D_screen_exited():
	queue_free();
