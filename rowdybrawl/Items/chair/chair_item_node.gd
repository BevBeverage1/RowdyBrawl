extends PlayerItemNode

const CHAIR_PROJECTILE := preload("uid://ijey8uixre4l")

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("lightAttack"):
		var ic := get_item_controller()

		ic.remove_item(ic.all_items.find(ic.current_item))

		var chair_projectile := CHAIR_PROJECTILE.instantiate()
		ic.player_node.get_parent().add_child(chair_projectile)
		chair_projectile.global_position = ic.player_node.player_sprite.global_position
		chair_projectile.shoot_chair(Vector2.RIGHT * signf(ic.player_node.facingDir), ic.current_item)
		ic.current_item.health_points -= 1
		
		
