extends KinematicBody2D

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
		queue_free();
	
	velocity = move_and_slide(velocity, Vector2.UP) # Added
	
	var collision = move_and_collide(velocity * delta);
	if collision:
		#queue_free(); # Removed
		pass

func _on_VisibilityNotifier2D_screen_exited():
	queue_free();
