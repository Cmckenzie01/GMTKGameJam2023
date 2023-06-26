extends TextureProgressBar

var bar_red = preload("res://assets/gui/barHorizontal_red_mid 200.png")
var bar_green = preload("res://assets/gui/barHorizontal_green_mid 200.png")
var bar_yellow = preload("res://assets/gui/barHorizontal_yellow_mid 200.png")

func _ready():
	hide()

@warning_ignore("shadowed_variable_base_class")
func update_health(_value, max_value):
	value = _value
	if value < max_value:
		show()
	texture_progress = bar_green
	if value < 0.75 * max_value:
		texture_progress = bar_yellow
	if value < 0.45 * max_value:
		texture_progress = bar_red
