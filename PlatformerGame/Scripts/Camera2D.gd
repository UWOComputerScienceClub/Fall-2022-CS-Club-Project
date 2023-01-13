extends Camera2D

onready var player = get_node("/root/MainScene/Player")

var gameOver;

func _ready():
	gameOver = false;

func _process(delta):
	if !gameOver:
		position.x = player.position.x;

func _on_Player_ded():
	gameOver = true;
