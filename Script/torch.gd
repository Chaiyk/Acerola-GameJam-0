extends StaticBody2D

func _process(_delta):
	$Timer_Bar.value = $Timer.time_left

func _on_timer_timeout():
	queue_free()
