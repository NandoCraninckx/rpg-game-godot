extends KinematicBody2D

var knockBack = Vector2.ZERO

onready var stats = $Stats

func _ready():
	print(stats.max_health)

func _physics_process(delta):
	knockBack = knockBack.move_toward(Vector2.ZERO, 200 * delta)
	knockBack = move_and_slide(knockBack)

# The area reverences to the object where this object collide with
# In this case the bat collide (comes in the area of the sword) 
func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockBack = area.knockback_vector * 120

# When the bat has no health anymore, it's automatically removed from the world
# The health from the bat is coupled by => Signals Node no_health
# Health is handled in the states Node itself
func _on_Stats_no_health():
	queue_free()
