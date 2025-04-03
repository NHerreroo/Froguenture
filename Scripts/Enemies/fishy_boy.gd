extends Enemy

var bullet = preload("res://Scenes/Enemies/Misc/EnemyBullet.tscn")
var currentState

func _ready() -> void:
	$AnimationPlayer.play("idle")
	
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	nav.target_position = player.global_transform.origin
