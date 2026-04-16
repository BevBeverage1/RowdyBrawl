extends BTAction

@export var player_variable_name := &"player"
@export var attack_list_variable_name := &"attack_list"

var _is_attacking: bool

func _tick(delta: float) -> Status:
	if not _is_attacking and not agent.canAttack():
		return FAILURE

	var attack_list: Array = blackboard.get_var(attack_list_variable_name, [])
	var player_reference: player = blackboard.get_var(player_variable_name)

	agent.facingDir = 1
	if (player_reference.playerBody.global_position - agent.global_position).x < 0:
		agent.facingDir = -1

	if agent.attackBusyTimer > 0:
		return RUNNING
	elif _is_attacking:
		_is_attacking = false
		return SUCCESS
	
	agent.spawnAttack(attack_list.pick_random(), 10, 1, 0.35, 0.1)
	_is_attacking = true

	return RUNNING
	
