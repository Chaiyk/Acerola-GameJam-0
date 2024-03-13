extends Node2D

#Battery Placer Var
var Battery_Scene = preload("res://Scene/Item Scene/battery.tscn")
var X_Max_Range: int = 1720
var Y_Max_Range: int = 880

#Wood Placer Var
var Wood_Scene = preload("res://Scene/Item Scene/wood.tscn")
var Wood_Place_Count: int = 60

#Eye Placer Var
var Eye_One = preload("res://Scene/Mob/mob_one_eye.tscn")
var Eye_Two = preload("res://Scene/Mob/mob_two_eye.tscn")
var Eye_Three = preload("res://Scene/Mob/mob_three_eye.tscn")
var Eye_Max_Count: int = 40

func _ready():
	#Reset Var
	Global.Battery_Holding = 0
	Global.Battery_Placed = 0 
	Global.Wood_Picked_Up = 0
	
	#Player Music
	if MusicManager.music_playeing == false:
		MusicManager.music_play()
	
	#Place Battery x3
	for i in 3:
		place_battery(Vector2(randi_range(100, X_Max_Range), randi_range(100, Y_Max_Range)))
	
	#Place Wood
	for i in Wood_Place_Count:
		place_wood(Vector2(randi_range(100, X_Max_Range), randi_range(100, Y_Max_Range)))
	
	for i in Eye_Max_Count:
		place_eye(Vector2(randi_range(100, X_Max_Range), randi_range(100, Y_Max_Range)))

#Place Battery Function
func place_battery(pos):
	var instantiate_battery = Battery_Scene.instantiate()
	instantiate_battery.position = pos
	add_child(instantiate_battery)

#Place Wood Function
func place_wood(pos):
	var instantiate_wood = Wood_Scene.instantiate()
	instantiate_wood.position = pos
	add_child(instantiate_wood)

#Place Eye Function
func place_eye(pos):
	var random_number = randi_range(1, 10)
	
	match random_number:
		1, 2:
			var instantiate_One_Eye = Eye_One.instantiate()
			instantiate_One_Eye.position = pos
			add_child(instantiate_One_Eye)
		3, 4, 5, 6, 10:
			var instantiate_Two_Eye = Eye_Two.instantiate()
			instantiate_Two_Eye.position = pos
			add_child(instantiate_Two_Eye)
		7, 8, 9:
			var instantiate_Three_Eye = Eye_Three.instantiate()
			instantiate_Three_Eye.position = pos
			add_child(instantiate_Three_Eye)
		_:
			return
