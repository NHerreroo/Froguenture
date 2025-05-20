extends Control

var current_tween: Tween

func _ready() -> void:
	current_tween = create_tween()
	current_tween.tween_property(self, "modulate:a", 1.0, 1.0).from(modulate.a)

func _on_button_pressed() -> void:
	Global.resetall()
	Global.lvlCount = 0
	Global.totalRuns += 1
	get_tree().change_scene_to_file("res://Scenes/run.tscn")

func _on_button_2_pressed() -> void:
	Global.can_walk = true
	if current_tween and current_tween.is_running():
		current_tween.kill()

	current_tween = create_tween()
	current_tween.tween_property(self, "modulate:a", 0.0, 1.0).from(modulate.a)
	current_tween.tween_callback(self.queue_free)
