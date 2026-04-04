class_name ChairProp
extends prop


var chair_player_item: ChairPlayerItem = preload("uid://6265qwevyyp0").duplicate()

func get_chair_and_queue_free() -> PlayerItem:
	queue_free()
	return chair_player_item
	
