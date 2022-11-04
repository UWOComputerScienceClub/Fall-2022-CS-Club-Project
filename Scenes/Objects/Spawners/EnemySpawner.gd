extends Area2D

# ----------------- Timer ----------------- #

onready var timer = get_node("Timer");
export var repeatSpawn = false;
export var secondsBetweenSpawns: float
var spawns = 0
var delayStart = true
export var maxSpawns = 20

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
var walkingEnemy = preload("res://Scenes/Objects/Enemies/WalkingEnemy/WalkingEnemy.tscn")
var flyingEnemy = preload("res://Scenes/Objects/Enemies/FlyingEnemy/FlyingEnemy.tscn")
var dashingEnemy = preload("res://Scenes/Objects/Enemies/DashingEnemy/DashingEnemy.tscn")
#...
#...
#...
onready var enemySpawner = get_parent()

# ----------------------------------------------------- #

func _ready():
	# Sets spawner transparency
	modulate.a = 0.5
	
	# Timer setup
	timer.set_wait_time(secondsBetweenSpawns)

func _process(_delta):
	if (delayStart):
		timer.start()
		delayStart = false
	if (spawnerProperties["Movement Type"] != "Static"):
		position += spawnerProperties["Movement"];
		pass
	
# Summons enemies based on timer value (set in editor)
func _on_Timer_timeout():
	spawns += 1
	if (spawns <= maxSpawns):
		call_deferred("summon_enemy")

# Summon enemies
func summon_enemy():
	var enemy

	# Instances enemies based on editor choices
	match (enemyType):
		"Walking Enemy":
			enemy = walkingEnemy.instance()
		"Dashing Enemy":
			enemy = dashingEnemy.instance()
		"Flying Enemy":
			enemy = flyingEnemy.instance()
		_:
			enemy = walkingEnemy.instance()

	# Setup for instanced enemy
	enemy.position = Vector2(position.x, position.y)
	
	if (!useEnemyDefaults):
		enemy.scale = enemyProperties["Scale"]
		enemy.init(enemyProperties["Movement Speed"], enemyProperties["Gravity"]);

	enemySpawner.add_child(enemy)
