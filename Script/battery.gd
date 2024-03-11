extends Node2D

var X_Max_Range: int = 1720
var Y_Max_Range: int = 880

func _on_spawn_area_area_entered(area):
	if (area.get_parent().get_groups()[0] == "Battery") || (area.get_parent().get_groups()[0] == "Torch"):
		position = Vector2(randi_range(100, X_Max_Range), randi_range(100, Y_Max_Range))


func _on_timer_timeout():
	$Spawn_Area.queue_free()
	$Timer.queue_free()
