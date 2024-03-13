extends Node2D

@onready var player = get_node("/root/Main Game/Player")

func _physics_process(_delta):
	var dir = get_parent().get_parent().position.direction_to(player.global_position)
	
	#Eye Ball Following Player Based on direction
	$Ball.position = dir * 1.5
