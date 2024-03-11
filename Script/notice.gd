extends Node2D

var SPEED: int = 10

func _physics_process(delta):
	position.y -= SPEED * delta

func _on_timer_timeout():
	queue_free()

