extends Node2D
		
func create_grass_effect():
	var GrassEffect = load("res://Effects/GrassEffect.tscn")
	var grassEffect = GrassEffect.instance() 
	
	# When the game starts it takes the first scene form this tree. In this case the world tree
	# Order from tree visable when starting the game, change the tab to Remote (left side, Scene)
	var world = get_tree().current_scene
	world.add_child(grassEffect)
	grassEffect.global_position = global_position


func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
