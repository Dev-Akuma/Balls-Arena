extends Label

var base_color = Color("b8d6ff")
var glow_color = Color("ffffff")

func _ready():
	animate_glow()

func animate_glow():
	var tween = create_tween().set_loops()

	# Brighten
	tween.tween_property(
		self,
		"modulate",
		glow_color,
		1.2
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	# Return to base
	tween.tween_property(
		self,
		"modulate",
		base_color,
		1.2
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
