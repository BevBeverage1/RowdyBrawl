@tool
extends Area2D
class_name enemyEncounter

signal round_started()
signal all_round_enemies_died()

@export var time_between_rounds: float = 2

@export var rounds: Array[EncounterRound]
var current_round_index := 0

var _alive_enemies_count: int


func _init() -> void:
	body_entered.connect(_on_player_trigger_body_entered)
	
	# logic for editor 
	child_order_changed.connect(update_configuration_warnings)


func spawnNextRound():
	if current_round_index >= rounds.size():
		push_error("No more rounds to spawn!")
		return

	var current_round: EncounterRound = rounds.get(current_round_index)
	
	var spawn_points := get_all_spawn_points()
	spawn_points.shuffle()

	var round_enemies := current_round.get_enemies_shuffled()
	for i in round_enemies.size():
		if i >= spawn_points.size(): 
			push_warning("There are more enemies than spawn points!")
			break
		
		var instance: Enemy = round_enemies[i].instantiate()
		instance.position = spawn_points[i].position
		instance.died.connect(_on_enemy_died)
		add_child.call_deferred(instance)

		_alive_enemies_count += 1
	
	round_started.emit()


		
func get_all_spawn_points() -> Array:
	return find_children("*", "Marker2D", true)


func _on_player_trigger_body_entered(body: Node2D) -> void:
	if body.get_parent() is player:
		body_entered.disconnect(_on_player_trigger_body_entered)
		spawnNextRound()

func _get_configuration_warnings() -> PackedStringArray:
	if not get_children().any(func(c): return c is Marker2D):
		return ["Must child Marker2D's as spawn points"]
	return []

func _on_enemy_died():
	_alive_enemies_count -= 1 
	
	if _alive_enemies_count <= 0:
		await get_tree().create_timer(time_between_rounds).timeout
		all_round_enemies_died.emit()
