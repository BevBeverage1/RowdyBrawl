extends BTAction

@export var tolerance: float

@export_group("Variable Names")
@export var player_variable_name := &"player"
@export var player_position_offest_variable_name := &"attack_position_player_offset"

func _tick(delta: float) -> Status:
	var player_position_offset: Vector2 = blackboard.get_var(player_position_offest_variable_name, Vector2.ZERO)
	var player_reference:player = blackboard.get_var(player_variable_name)

	var target_global_pos := player_reference.playerBody.global_position + player_position_offset

	agent.moveDirection = agent.global_position.direction_to(target_global_pos)

	if (target_global_pos - agent.global_position).length() < tolerance:
		agent.moveDirection = Vector2.ZERO
		return SUCCESS

	else: 
		return RUNNING
