extends Node2D


@onready var collect_area: Area2D = %CollectArea
@onready var hover_animation: AnimationPlayer = %HoverAnimation

@export var player_item: PlayerItem

func _ready() -> void:
	collect_area.body_entered.connect(_on_body_entered)
	hover_animation.play("hover")


func _on_body_entered(body: PhysicsBody2D):
	var body_parent := body.get_parent()
	if body_parent and body_parent is player:
		var player_node: player = body_parent
		player_node.item_controller.add_item(player_item.duplicate())
		queue_free()
