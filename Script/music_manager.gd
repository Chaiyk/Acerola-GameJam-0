extends Node2D

var play_music: int
var music_playing: bool = false

func music_play():
	play_music = randi_range(1, 3)
	music_playing = true
	
	match play_music:
		1:
			$Music_1.play()
			set_timer(randi_range(30, 35))
		2:
			$Music_2.play()
			set_timer(randi_range(28, 33))
		3:
			$Music_3.play()
			set_timer(randi_range(48, 53))

func set_timer(duration):
	$Timer.wait_time = duration
	$Timer.start()

func _on_timer_timeout():
	music_play()
