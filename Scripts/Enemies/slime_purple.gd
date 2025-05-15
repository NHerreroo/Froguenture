extends Enemy

var currentState

func _ready() -> void:
	Global.enemies_remaining += 1
	await get_tree().create_timer(1).timeout
	var canStart = false
	while !canStart:
		await get_tree().create_timer(0.2).timeout
		if Global.dialog_ended == true:
			canStart = true
	enem_area_disabled()
	$AnimationPlayer.play("idle")
	selectState()


func selectState():
	speed = 3
	currentState = get_random_state()
	match currentState:
		State.IDLE:
			idleState()
		State.WALK:
			walkState()
		State.ATTACK:
			attackState()

func walkState():
	$AnimationPlayer.play("idle")
	print("walk")
	var posx = randf_range(-3.0, 3.0)
	var posz = randf_range(-6.0, 6.0)
	nav.target_position = global_transform.origin + Vector3(posx, 0, posz)

	var timer = get_tree().create_timer(4.0)
	await get_tree().create_timer(4.0).timeout or nav.navigation_finished
	selectState()

func idleState():
	$AnimationPlayer.play("idle")
	print("idle")
	await get_tree().create_timer(randf_range(0.5,1.5)).timeout
	selectState()
	
func attackState():
	print("attack")
	velocity = Vector3.ZERO
	$AnimationPlayer.play("prepare")
	await get_tree().create_timer(1.5).timeout
	var original_speed = speed
	speed *= 5
	$AnimationPlayer.play("attack")
	enem_area_enabled()
	nav.target_position = player.global_transform.origin
	var timer = get_tree().create_timer(4.0)
	await get_tree().create_timer(4.0).timeout or nav.navigation_finished
	speed = 3
	enem_area_disabled()
	selectState()
