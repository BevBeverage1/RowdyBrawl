@tool
extends Area2D
class_name enemyEncounter

signal encounter_activated()
signal encounter_ended()
signal round_started()
signal all_round_enemies_died()


@export var time_between_rounds: float = 2

@export var rounds: Array[EncounterRound]
@export var delete_on_encounter_ended: Array[NodePath]
var current_round_index := 0

var boundaries: StaticBody2D

var _alive_enemies_count: int


func _init() -> void:
	body_entered.connect(_on_player_trigger_body_entered)
	
	# logic for editor 
	child_order_changed.connect(update_configuration_warnings)


func _ready() -> void:
	if get_children().any(func(c): return c is StaticBody2D):
		boundaries = get_child(get_children().find_custom(func(c): return c is StaticBody2D))
		boundaries.collision_layer = 0
		encounter_activated.connect(func(): boundaries.collision_layer = 3)


func spawnCurrentRound():
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
		
		# spawn enemy
		var instance: Enemy = round_enemies[i].instantiate()
		instance.position = spawn_points[i].position
		instance.died.connect(_on_enemy_died)
		add_child.call_deferred(instance)

		_alive_enemies_count += 1
	
	round_started.emit()


		
## returns Array[Marker2D] of all child spawn points
func get_all_spawn_points() -> Array:
	return find_children("*", "Marker2D", true)


func _on_player_trigger_body_entered(body: Node2D) -> void:
	if body.get_parent() is player:
		_on_encounter_activated()


func _on_encounter_activated():
	body_entered.disconnect(_on_player_trigger_body_entered)
	encounter_activated.emit()
	spawnCurrentRound()


func _on_encounter_ended():
	# delete nodes
	for nodepath: NodePath in delete_on_encounter_ended:
		var node = get_node(nodepath)
		if node:
			node.queue_free()

	# emit signals
	encounter_ended.emit()
	GameGlobals.encounter_finished.emit()



func _get_configuration_warnings() -> PackedStringArray:
	if not get_children().any(func(c): return c is Marker2D):
		return ["Must child Marker2D's as spawn points"]
	return []

func _on_enemy_died():
	_alive_enemies_count -= 1 
	print(_alive_enemies_count)
	
	if _alive_enemies_count <= 0:
		all_round_enemies_died.emit()
		current_round_index += 1

		await get_tree().create_timer(time_between_rounds).timeout
		
		if current_round_index < rounds.size():
			spawnCurrentRound()
		else:
			_on_encounter_ended()
