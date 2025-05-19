extends Node3D

@onready var label_3d: Label3D = $Label3D
var modalStats = preload("res://Scenes/viewStatsModal.tscn")
var playerRange = false
var currentModal = null
var tween: Tween

func _ready():
	label_3d.modulate.a = 0.0

func _process(delta):
	if playerRange and Input.is_action_just_pressed("Confirm"):
		if currentModal == null:
			spawnModal()

func _on_area_3d_body_entered(body: Node3D):
	if body.is_in_group("player"):
		playerRange = true
		fade_label(true)  # Fade in

func _on_area_3d_body_exited(body: Node3D):
	if body.is_in_group("player"):
		playerRange = false
		fade_label(false)  # Fade out
		if currentModal:
			currentModal.queue_free()
			currentModal = null

func fade_label(show: bool):
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
	if show:
		tween.tween_property(label_3d, "modulate:a", 1.0, 0.5) 
	else:
		tween.tween_property(label_3d, "modulate:a", 0.0, 0.5)

func spawnModal():
	currentModal = modalStats.instantiate()
	get_tree().root.add_child(currentModal)
