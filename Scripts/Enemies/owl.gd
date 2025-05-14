extends Enemy

var bullet = preload("res://Scenes/Enemies/Misc/EnemyBullet.tscn")
var mark = preload("res://Scenes/Enemies/Mark.tscn")
var slime = preload("res://Scenes/Enemies/Slime_Purple.tscn")


var attacksDone = 0
var rotation_offset := 0.0
	
	
func _process(delta: float) -> void:
	if Global.debilited == true:
		$Sprites.visible = false
	if Global.debilited == false:
		$Sprites.visible = true

func _ready() -> void:
	$AnimationPlayer.play("idle")
	await get_tree().create_timer(1).timeout

	while true:
		await get_tree().create_timer(1.5).timeout
		if Global.debilited == false:
			var rand_attack = randi_range(0, 2)
			match rand_attack:
				0:
					await shotsAttk()
				1:
					await markAttk()
				2:
					await slimeAttack()
			attacksDone += 1
			if attacksDone == 1:
				Global.debilited = true
				attacksDone = 0
				

func shotsAttk():
	for i in range(10):
		shoot_in_multiple_directions()
		await get_tree().create_timer(1).timeout  # un pequeño delay entre ráfagas

func markAttk():
	for i in range(5):
		spawn_marks()
		await get_tree().create_timer(3).timeout

func slimeAttack():
	for i in range(3):
		spawn_slime()
		await get_tree().create_timer(0).timeout


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

func spawn_marks():
	var n1 = randf_range(-4, 4)
	var n2 = randf_range(-7, 7)
	
	var new_mark = mark.instantiate()
	var new_pos = Vector3(n1, 0, n2)
	new_mark.global_transform.origin = new_pos
	get_tree().root.add_child(new_mark)

func spawn_slime():
	var player = get_tree().get_root().find_child("player", true, false)
	var max_attempts = 10
	var min_distance = 3.0

	for i in range(max_attempts):
		var x = randf_range(-4, 4)
		var z = randf_range(-7, 7)
		var candidate_position = Vector3(x, 0, z)
		
		if player and player.global_transform.origin.distance_to(candidate_position) >= min_distance:
			var new_slime = slime.instantiate()
			new_slime.global_transform.origin = candidate_position
			get_tree().root.add_child(new_slime)
			new_slime.spawn_dust()
			break
