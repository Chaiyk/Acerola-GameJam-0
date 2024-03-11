extends Node2D

var number_array = [ \
	load("res://Sprite/Number/Number_0.png"), \
	load("res://Sprite/Number/Number_1.png"), \
	load("res://Sprite/Number/Number_2.png"), \
	load("res://Sprite/Number/Number_3.png"), \
	load("res://Sprite/Number/Number_4.png"), \
	load("res://Sprite/Number/Number_5.png"), \
	load("res://Sprite/Number/Number_6.png"), \
	load("res://Sprite/Number/Number_7.png"), \
	load("res://Sprite/Number/Number_8.png"), \
	load("res://Sprite/Number/Number_9.png"), \
	]

func update_num(num):
	if (num > 9):
		$count_2.texture = number_array[num % 10]
		$count_1.texture = number_array[num / 10]
	else:
		$count_2.texture = number_array[num]

