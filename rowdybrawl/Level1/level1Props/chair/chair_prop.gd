class_name ChairProp
extends prop


const CHAIR_PLAYER_ITEM: PlayerItem = preload("uid://6265qwevyyp0")

func get_chair_and_queue_free() -> PlayerItem:
    queue_free()
    return CHAIR_PLAYER_ITEM.duplicate()
    
