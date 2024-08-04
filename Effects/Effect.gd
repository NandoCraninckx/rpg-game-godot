extends AnimatedSprite

func _ready():
	# Connect the standard signal using code so that when this Node is used by other Nodes, the animation 
	# is automatically passed to all the other Nodes that inherit from this one.
	connect("animation_finished", self, "_on_animation_finished")
	play("Animate")
	
func _on_animation_finished():
	queue_free()
