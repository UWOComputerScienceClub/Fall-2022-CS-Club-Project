extends Area2D

var scene
var enemy

export(String, "Walking Enemy", "Dashing Enemy", "Sin Wave Enemy") var enemyType = "Walking Enemy"
export var enemyMovementSpeed = 1
export var enemyGravity = 800
export var repeat = false
export var timeBetweenSpawns = 10
var timer = 0

func _ready():
	summon_enemy()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (repeat):
		timer += 60 * delta
		if (timer > timeBetweenSpawns):
			timer = 0
			summon_enemy()

func summon_enemy():
	match (enemyType):
		"walking":
			enemy = preload("res://WalkingEnemy.tscn").instance()
		_:
			enemy = preload("res://WalkingEnemy.tscn").instance()
	enemy.init(enemyMovementSpeed, enemyGravity)
	add_child(enemy)
	pass
