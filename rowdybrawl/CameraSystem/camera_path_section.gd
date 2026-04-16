class_name CameraPathSection
extends Area2D

@export var camera_follow_path: CameraPath


func _init() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	
func _on_body_entered(body: PhysicsBody2D):
	if body.get_parent() is player:
		camera_follow_path.entered_section(self)
		
func _on_body_exited(body: PhysicsBody2D):
	if body.get_parent() is player:
		camera_follow_path.exited_section(self)
