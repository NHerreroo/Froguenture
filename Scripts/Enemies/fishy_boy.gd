extends Enemy

var bullet = preload("res://Scenes/Enemies/Misc/EnemyBullet.tscn")
var currentState
var follow = false

func _ready() -> void:
	var current_pos = [Global.playerMapPositionX, Global.playerMapPositionY]
	if current_pos in Global.rooms_visited:
		queue_free()
	Global.enemies_remaining += 1
	await get_tree().create_timer(1).timeout
	follow = true
	$AnimationPlayer.play("idle")
	
	
func _physics_process(delta: float) -> void:
	if follow == true:
		super._physics_process(delta)
		nav.target_position = player.global_transform.origin
