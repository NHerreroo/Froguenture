extends Node3D

@onready var music: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	Global.persistent_items.clear()
	
	$AudioStreamPlayer.volume_db = -70
	$AudioStreamPlayer2.volume_db = -70
	$AudioStreamPlayer.play()
	$AudioStreamPlayer2.play()
	_fade_in_music()
	Global.setMapDificulty()
	$ColorRect2/AnimationPlayer.play("in")
	Player.setBaseStats()
	Player.notify_health_updated()
	
func _process(delta: float) -> void:
		Global.runEnded = true
		Engine.time_scale = 1
	


func _fade_in_music():
	while music.volume_db < -20:
		music.volume_db += 3
		$AudioStreamPlayer2.volume_db += 3
		await get_tree().create_timer(0.01).timeout

func _fade_out_music():
	while music.volume_db > -40:
		music.volume_db -= 3
		$AudioStreamPlayer2.volume_db -= 3
		await get_tree().create_timer(0.01).timeout
