extends Node

func _ready():
	$FadeController/Fader.play("fade_in")

func _input(event):
	if event is InputEventKey or event is InputEventJoypadButton:
		disable_input(true) # Disable input so we can't spam buttons
		
		# Block until the fade_out animation is done
		$FadeController/Fader.play("fade_out")
		yield($FadeController/Fader, "animation_finished")
		
		# Change to level 1 scene
		get_tree().change_scene("res://src/game/levels/LevelOne.tscn")

func disable_input(toggle):
	get_tree().get_root().set_disable_input(toggle)