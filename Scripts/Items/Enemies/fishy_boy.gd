extends Enemy

var bullet = preload("res://Scenes/Enemies/Misc/EnemyBullet.tscn")
var currentState

func _ready() -> void:
	$AnimationPlayer.play("RESET")
	Global.enemies_remaining += 1
	await get_tree().create_timer(1.5).timeout
	$AnimationPlayer.play("idle")
	nav.target_position = player.global_transform.origin
	
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
