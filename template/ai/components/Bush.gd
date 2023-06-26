extends CharacterBody2D

func _on_Area2D_body_entered(_body):
	$AnimationPlayer.play("shake")

func _on_Area2D_body_exited(_body):
	$AnimationPlayer.play("shake")



func _on_Area2D2_body_entered(_body):
	queue_free()
