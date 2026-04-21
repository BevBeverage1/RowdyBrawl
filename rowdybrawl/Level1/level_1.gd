extends Node2D
class_name level1

@onready var color_rect: AnimationPlayer = $ColorRect/AnimationPlayer
@onready var arrows_animator: AnimationPlayer = %ContinueArrowsAnimator

func _ready() -> void:
	fadeIn()
	GameGlobals.encounter_finished.connect(blink_arrows)
	
func fadeIn():
	color_rect.play("fadeOut")

func fadeOut():
	color_rect.play("fadeIn")

func blink_arrows():
	arrows_animator.play("blink")

