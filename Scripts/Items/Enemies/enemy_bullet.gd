extends Node3D


var direction = Vector3.ZERO
var speed = 10

func _process(delta):
	if Global.eraseLevel == true:
		queue_free()
	if direction != Vector3.ZERO:
		position += direction.normalized() * speed * delta


func _ready():
	await get_tree().create_timer(4).timeout
	queue_free()


func _on_area_3d_area_entered(area: Area3D) -> void:
		if area.is_in_group("player") and Player.is_dashing == false:
			queue_free()
