extends CharacterBody2D

@onready var player = get_node("/root/Main Game/Player")

var SPEED : int = 50
var BACK : bool = false

func _ready():
	#Move
	$Move_Timer.wait_time = randf_range(1, 7)
	$Move_Timer.start()
	
	#Blink
	await get_tree().create_timer(randi_range(1, 7)).timeout
	blink_timer()

func _physics_process(_delta):
	var dir = global_position.direction_to(player.position)
	
	velocity = dir * SPEED
	move_and_slide()
	
	if $Move_Timer.time_left == 0:
		time_out()

func time_out():
	if BACK == false:
		SPEED = randi_range(-20, -50)
		BACK = true
	else:
		SPEED = randi_range(60, 100)
		BACK = false
	
	$Move_Timer.wait_time = randf_range(1, 7)
	$Move_Timer.start()

func blink_timer():
	await get_tree().create_timer(randi_range(3, 7)).timeout
	blink()
	
func blink():
	$All_Eye.visible = !$All_Eye.visible
	await get_tree().create_timer(0.2).timeout
	$All_Eye.visible = !$All_Eye.visible
	blink_timer()
