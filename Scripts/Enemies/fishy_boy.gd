extends Enemy

var bullet = preload("res://Scenes/Enemies/Misc/EnemyBullet.tscn")
var currentState

var walk = false

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	Global.enemies_remaining += 1
	$AnimationPlayer.play("idle")
	walk = true
	
	
func _physics_process(delta: float) -> void:
	if walk:
		super._physics_process(delta)
		nav.target_position = player.global_transform.origin
