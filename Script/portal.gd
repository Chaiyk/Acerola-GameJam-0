extends Node2D

@export var portal_zero: Resource
@export var portal_one: Resource
@export var portal_two: Resource
@export var portal_three: Resource
@export var portal_open: Resource

var portal_spin_speed: int = 6
var portal_spin_status: bool = false

func _process(delta):
	#Change Sprite based on Battery Placed
	match Global.Battery_Placed:
		1:
			$Sprite.texture = portal_one
		2:
			$Sprite.texture = portal_two
		3:
			$Sprite.texture = portal_open
			%Portal_Back.visible = true
			portal_spin_status = true
		_:
			$Sprite.texture = portal_zero
	
	#Portal background spin
	if (portal_spin_status == true):
		%Portal_Back.rotation += portal_spin_speed * delta

#Setting Current Portal with key pressed
func _input(event):
	if (Global.debug_mode == true):
		match event.as_text():
			"1":
				Global.Battery_Placed = 1
			"2":
				Global.Battery_Placed = 2
			"3":
				Global.Battery_Placed = 3
			"4":
				Global.Battery_Placed = 4
			"5":
				Global.Battery_Placed = 0
