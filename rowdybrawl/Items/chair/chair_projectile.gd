class_name ChairProjectile
extends Node2D

const CHAIR_PROP := preload("uid://xhr53n02vutg")

@onready var tween := create_tween()

func shoot_chair(direction: Vector2):
    var dir := signf(direction.dot(Vector2.RIGHT))
    tween.tween_property(self, "position", position + Vector2(dir * 300, 0), 1)
    tween.parallel().tween_property(self, "rotation",  dir * (PI * 3 + PI * randf()), 1)
    tween.tween_callback(spawn_prop_and_queue_free)


func spawn_prop_and_queue_free():
    var prop := CHAIR_PROP.instantiate()
    add_sibling(prop)
    prop.global_position = global_position
    queue_free()
    
