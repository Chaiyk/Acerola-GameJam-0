extends Node2D

func _ready():
	await get_tree().create_timer(1.5).timeout

func _on_timer_timeout():
	$Right_Eye.queue_free()
	$Left_Eye.queue_free()
	$The_End.visible = true
	$The_End2.visible = true
	$Restart.visible = true
