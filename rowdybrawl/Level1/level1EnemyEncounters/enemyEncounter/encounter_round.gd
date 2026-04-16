class_name EncounterRound
extends Resource

@export var _enemies_to_spawn: Array[PackedScene]


func get_enemies_shuffled() -> Array[PackedScene]:
    var arr := _enemies_to_spawn.duplicate()
    arr.shuffle()
    return arr
    
