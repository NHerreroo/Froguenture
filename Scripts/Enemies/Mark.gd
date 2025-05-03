extends Sprite3D

var dust = preload("res://Scenes/Enemies/dust.tscn")
var bullet = preload("res://Scenes/Enemies/Misc/EnemyBullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../AnimationPlayer".play("Entery")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func flash():
	var time = 0.5
	while time > 0:
		self.visible = true
		await get_tree().create_timer(time).timeout
		self.visible = false
		await get_tree().create_timer(time).timeout
		time -= 0.06
	spawn_dust()
	shoot_in_multiple_directions()
		

func spawn_dust():
	var dust_instance = dust.instantiate()
	dust_instance.global_transform.origin = self.global_transform.origin + Vector3(0, 0.5, 0)
	get_tree().root.add_child(dust_instance)


var rotation_offset := 0.0
func shoot_in_multiple_directions():
	var bullet_count := 16
	var angle_step := 360.0 / bullet_count
	
	for i in range(bullet_count):
		var angle_deg = i * angle_step + rotation_offset
		var angle_rad = deg_to_rad(angle_deg)
		var direction = Vector3(cos(angle_rad), 0, sin(angle_rad)).normalized()
		
		var bullet_instance = bullet.instantiate()
		bullet_instance.global_transform.origin = self.global_transform.origin
		bullet_instance.direction = direction
		get_tree().root.add_child(bullet_instance)
		
	rotation_offset += 10.0
