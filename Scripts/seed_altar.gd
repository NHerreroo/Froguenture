extends Node3D

@onready var nine_patch_rect = $CanvasLayer/NinePatchRect
@onready var item_sprite = $Item
var dust = preload("res://Scenes/Enemies/dust.tscn")
var pack = preload("res://Items/ItemCardSelector.tscn")

var stats = preload("res://Scenes/run_final_stats.tscn")

var currentItem : String
var playerInArea = false
var disableShop = false
var purchased = false

func _ready() -> void:
	$AnimationPlayer.play("float")

func _process(delta: float) -> void:
	set_controller_text()
	if playerInArea:
		buy_item()
		
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		animate_nine_patch_rect(true)
		playerInArea = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		animate_nine_patch_rect(false)
		playerInArea = false

func buy_item():
	if Input.is_action_just_pressed("Confirm") and purchased == false:
		$Item.visible = false
		$Item/Item2.visible = false
		purchased = true
		spawn_dust()
		animate_nine_patch_rect(false)
		spawnStats()
			

func animate_nine_patch_rect(show: bool) -> void:
	var tween = create_tween().set_parallel(true)
	if show:
		nine_patch_rect.visible = true
		tween.tween_property(nine_patch_rect, "position", Vector2(485.0, 796.0), 0.2)
		tween.parallel().tween_property(nine_patch_rect, "modulate:a", 1.0, 0.2)
	else:
		tween.tween_property(nine_patch_rect, "position", Vector2(485.0, 796.0), 0.2)
		tween.parallel().tween_property(nine_patch_rect, "modulate:a", 0.0, 0.2)
		await tween.finished
		nine_patch_rect.visible = false

func set_controller_text():
	var boxText = "Get The Ancient Seed" 
	$CanvasLayer/NinePatchRect/Price.text = str(boxText)
	if Global.controller_active:
		$CanvasLayer/NinePatchRect/Text.text = "Press 'O' To Get The Seed"
	else:
		$CanvasLayer/NinePatchRect/Text.text = "Press 'E' To Get The Seed"


func spawn_dust():
	var dust_inst = dust.instantiate()
	dust_inst.position = Vector3(self.position.x, 0 ,self.position.z)
	get_tree().root.add_child(dust_inst)
	

func spawnStats():
	var newStats = stats.instantiate()
	add_child(newStats)
