extends Area2D

# ----------------- Timer ----------------- #

onready var timer = get_node("Timer");
export var repeatSpawn = false;
export var secondsBetweenSpawns: float

# ----------------- Enemy Properties ----------------- #

# Exports possible enemy types to editor. Defaults to "Walking Enemy" (temp name).
export(String, "Walking Enemy", "Flying Enemy", "Dashing Enemy") var enemyType = "Walking Enemy"

# No non-essential properties are passed to instantiated enemies if true.
export var useEnemyDefaults = true

# Dictionary for all properties that can be passed to instantiated enemies.
# Only used if useEnemyDefaults = false.
export var enemyProperties = {
	"Scale": Vector2(1,1),
	"Movement Speed": 200,
	"Gravity": 800
}

# ----------------- Spawner Properties ----------------- #

# Dictionary for all properties exclusive to the spawner itself
export var spawnerProperties = {
	"Transparency": 1, # 0 - 1
	"Movement Type": "Static", # Static, Linear, Sin
	"Movement": Vector2(0,0)
}

# ----------------- Preloading Objects ----------------- #

# Preloads all enemy types
var walkingEnemy = preload("res://Scenes/Objects/WalkingEnemy.tscn")
var flyingEnemy = preload("res://Scenes/Objects/FlyingEnemy.tscn")
#...
#...
#...
onready var enemySpawner = get_parent()

# ----------------------------------------------------- #

func _ready():
	# Sets spawner transparency
	modulate.a = 0.5
	
	# Timer setup
	if (repeatSpawn):
		timer.set_wait_time(secondsBetweenSpawns)
		timer.start()
	call_deferred("summon_enemy")

func _process(delta):
	if (spawnerProperties["Movement Type"] != "Static"):
		position += spawnerProperties["Movement"];
		pass
	
# Summons enemies based on timer value (set in editor)
func _on_Timer_timeout():
	call_deferred("summon_enemy")
	pass # Replace with function body.

# Summon enemies
func summon_enemy():
	var enemy

	# Instances enemies based on editor choices
	match (enemyType):
		"Walking Enemy":
			enemy = walkingEnemy.instance()
		"Flying Enemy":
			enemy = flyingEnemy.instance()
		_:
			enemy = flyingEnemy.instance()

	# Setup for instanced enemy
	enemy.position = Vector2(position.x, position.y)
	
	if (!useEnemyDefaults):
		enemy.scale = enemyProperties["Scale"]
		enemy.init(enemyProperties["Movement Speed"], enemyProperties["Gravity"]);

	enemySpawner.add_child(enemy)
