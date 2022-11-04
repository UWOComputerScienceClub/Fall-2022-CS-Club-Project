extends ProgressBar

var regen: bool
var regenValue
var firstTick = true

func _ready():
	visible = false
	pass

func _process(_delta):
	if (firstTick):
		max_value = get_parent().maxHealth
		firstTick = false

func updateBar():
	value = get_parent().health
	visible = true
