extends CharacterBody2D

var End_Game: bool = false
var Game_Over: bool = false
var True_Game_Over: bool = false

#Player Stat Var
var SPEED : int = 100
var MAX_HEALTH: int = 100
var CUR_HEALTH: int
var timer_setter: bool = true
var timer_duration: float = 0.15

#Torch Placer Var
var wood_place_count: int = 2
var torch = preload("res://Scene/Item Scene/torch.tscn")

#Icon Var
var icon_count: int = 0
var ui_battery: bool = false
var ui_wood: bool = false
var icon_pos_1 = Vector2(170, 100)
var icon_pos_2 = Vector2(170, 80)

#Notice Var
var notice_pos = Vector2(0, -20)

#GameOver & YouLose Var
var Game_Over_Scene = preload("res://Scene/game_over_scene.tscn").instantiate()
var You_Lose_Scene = preload("res://Scene/you_lose_scene.tscn").instantiate()

#-------------------------------------------------------------------#

func _ready():
	#Setting Visible
	%E_Key.visible = false
	$wood_count.visible = false
	$battery_count.visible = false
	$ui_torch.visible = false
	
	
	#Set Current Health
	CUR_HEALTH = MAX_HEALTH
	$"Camera2D/Health Bar".value = CUR_HEALTH

func _physics_process(_delta):
	#Movement
	var direction = Input.get_vector("Move_Left", "Move_Right", "Move_Up", "Move_Down")
	velocity = direction * SPEED
	move_and_slide()
	
	if (velocity.x != 0) || (velocity.y != 0):
		$"Player Sprite".play("moving")
	else:
		$"Player Sprite".play("idle")
	
	#Arrow Aim to a Battery
	arrow_rotation()

func _process(_delta):
	#Place Torch "F"
	if Input.is_action_just_released("Place"):
		place_torch(global_position)
		update_number()
	#Pick Up "E"
	if Input.is_action_just_released("Interact"):
		if (icon_count < 2):
			add_count_icon()
		interact()
		update_number()
	#Set Debug Mode "P"
	if Input.is_action_just_released("Debug_Mode"):
		set_debug_mode()
	
	#Health Management
	if End_Game == false || Game_Over == true:
		health_checker()
	
	#Game Restart
	if Input.is_action_just_released("Restart"):
		if End_Game == true || True_Game_Over == true:
			get_tree().reload_current_scene()
	
	#E Key Visibility Control
	e_key_visible()

func _on_timer_timeout():
	#Minus Health, Timer Set in "health_checker()"
	CUR_HEALTH -= 1
	$"Camera2D/Health Bar".value = CUR_HEALTH
	timer_setter = true

#Place Torch Function
func place_torch(pos):
	var instance = torch.instantiate()
	
	#Minus Wood
	if (Global.Wood_Picked_Up >= 2):
		Global.Wood_Picked_Up -= wood_place_count
		instance.position = pos
		get_parent().add_child(instance)
	else:
		insta_notice(1)

#Pick Up Function
func interact():
	var body = $PickUpArea.get_overlapping_areas()
	
	#Checking Area is Empty
	if (body.is_empty()):
		return null
	
	for touching in body:
		match touching.get_parent().get_groups()[0]:
			#Pick Up Battery
			"Battery":
				touching.get_parent().queue_free()
				Global.Battery_Holding += 1
				return
			#Pick Up Wood
			"Wood":
				touching.get_parent().queue_free()
				Global.Wood_Picked_Up += 1
				return
			#interact With Portal
			"Portal":
				if (Global.Battery_Holding > 0):
					Global.Battery_Holding -= 1
					Global.Battery_Placed += 1
				elif (Global.Battery_Holding == 0) && (Global.Battery_Placed < 3):
					insta_notice(2)
				elif (Global.Battery_Placed == 3):
					add_child(Game_Over_Scene)
					Game_Over = true
					await get_tree().create_timer(8).timeout
					True_Game_Over = true
				return
			_:
				continue

#Notice Pop Up Function
func insta_notice(type):
	var insta_notice_wood = preload("res://Scene/Notice/notice_wood.tscn").instantiate()
	var insta_notice_bat = preload("res://Scene/Notice/notice_battery.tscn").instantiate()
	
	match type:
		1:
			insta_notice_wood.position = (position + notice_pos)
			get_parent().add_child(insta_notice_wood)
		2:
			insta_notice_bat.position = (position + notice_pos)
			get_parent().add_child(insta_notice_bat)

#E Key Visibility Function
func e_key_visible():
	var body = $PickUpArea.get_overlapping_areas()
	
	for touching in body:
		if touching.get_parent().get_groups()[0] != "Torch":
			%E_Key.visible = true
			return
		else:
			%E_Key.visible = false

#Arrow Aim to a Battery/Portal Function
func arrow_rotation():
	var battery = get_tree().get_nodes_in_group("Battery")
	var portal = get_tree().get_nodes_in_group("Portal")
	
	if (battery.is_empty()):
		#Aim to Portal
		$Arrow.rotation = (portal[0].position - position).angle()
	else:
		#Aim to First Battery
		$Arrow.rotation = (battery[0].position - position).angle()

#Add Count Icon
func add_count_icon():
	var body = $PickUpArea.get_overlapping_areas()
	
	#Checking Area is Empty
	if (body.is_empty()):
		return null
	
	for touching in body:
		match touching.get_parent().get_groups()[0]:
			"Battery":
				if (ui_battery == false):
					icon_count += 1
					if (icon_count == 1):
						$battery_count.position = icon_pos_1
					else:
						$battery_count.position = icon_pos_2
					$battery_count.visible = true
					ui_battery = true
			"Wood":
				if (ui_wood == false):
					icon_count += 1
					if (icon_count == 1):
						$wood_count.position = icon_pos_1
					else:
						$wood_count.position = icon_pos_2
					$wood_count.visible = true
					$ui_torch.visible = true
					ui_wood = true
			_:
				continue

#Update Count
func update_number():
	if ui_wood == true:
		$wood_count.update_num(Global.Wood_Picked_Up)
	
	if ui_battery == true:
		$battery_count.update_num(Global.Battery_Holding)

#Go Into Darkness
func health_checker():
	var body = $PickUpArea.get_overlapping_areas()
	
	if (CUR_HEALTH <= 0) && (End_Game == false):
		add_child(You_Lose_Scene)
		End_Game = true
	
	for touching in body:
		if touching.get_parent().get_groups()[0] == "Torch":
			return
	
	if timer_setter == true && Game_Over == false:
		$Timer.wait_time = timer_duration
		$Timer.start()
		timer_setter = false

#Debug Mode Stuff
#1-4 Portal Current Placed Battery
#7 Add Wood
#8 Add Battery
#0 Reset Scene
func set_debug_mode():
	Global.debug_mode = !Global.debug_mode
	print("Debug Mode: ", Global.debug_mode)
func _input(event):	
	if (event.as_text() == "7") && (Global.debug_mode == true):
		Global.Wood_Picked_Up += 1
		
	if (event.as_text() == "8") && (Global.debug_mode == true):
		Global.Battery_Holding += 1
		
	if (event.as_text() == "0") && (Global.debug_mode == true):
		print("Game Restart")
		get_tree().reload_current_scene()
		
	if (event.as_text() == "Minus") && (Global.debug_mode == true):
		print("End")
		CUR_HEALTH = 0
