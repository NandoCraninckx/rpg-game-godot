extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = CHASE

var velocity = Vector2.ZERO
var knockBack = Vector2.ZERO

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision

func _physics_process(delta):
	knockBack = knockBack.move_toward(Vector2.ZERO, 200 * delta)
	knockBack = move_and_slide(knockBack)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			
		WANDER:
			pass
			
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)
			
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

# The area reverence to the object where this object collide with
# In this case the bat collide (comes in the area of the sword) 
func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockBack = area.knockback_vector * 120
	hurtbox.create_hit_effect()

# When the bat has no health anymore, it's automatically removed from the world
# The health from the bat is coupled by => Signals Node no_health
# Health is handled in the states Node itself
func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
