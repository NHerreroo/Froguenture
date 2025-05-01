extends Node

# Velocidad del fade (db por segundo)
const FADE_SPEED: float = 38.0
const MAXVOL = -35

var target_song: AudioStreamPlayer = null
var current_song: AudioStreamPlayer = null

func _ready() -> void:
	$Normal.play()
	$Normal.volume_db = -80
	$Fight.play()
	$Fight.volume_db = -80
	$Shop.play()
	$Shop.volume_db = -80

	current_song = $Normal
	target_song = $Normal

func _process(delta: float) -> void:
	update_target_song()
	update_volume(delta)
	
func update_target_song():
	if Global.map[Global.playerMapPositionX][Global.playerMapPositionY] == "$":
		target_song = $Shop
	elif Global.enemies_remaining > 0:
		target_song = $Fight
	else: 
		target_song = $Normal

func update_volume(delta: float):

	if target_song != current_song:
		current_song = target_song
	
	for song in [$Normal, $Fight, $Shop]:
		if song == current_song:

			song.volume_db = move_toward(song.volume_db, MAXVOL, FADE_SPEED * delta)
		else:
			# Fade out para las demás canciones
			song.volume_db = move_toward(song.volume_db, -80, FADE_SPEED * delta)
