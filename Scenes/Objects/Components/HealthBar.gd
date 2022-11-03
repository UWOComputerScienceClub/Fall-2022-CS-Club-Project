extends ProgressBar

var regen: bool
var regenValue

func _ready():
	max_value = get_parent().maxHealth

func updateBar():
	value = get_parent().health
