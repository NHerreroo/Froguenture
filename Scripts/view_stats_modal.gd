extends Control

var current_tween: Tween

func _ready() -> void:
	current_tween = create_tween()
	current_tween.tween_property(self, "modulate:a", 1.0, 1.0).from(modulate.a)
	$Title.text = str("Your Stats")
	$Time.text = "Total Time In Runs: " + format_time(Global.totalTime)
	$Kills.text = "Total Kills: " + str(Global.totalKills)
	$Floors.text = "Total Floors: " + str(Global.totalFloors)
	$Runs.text = "Total Runs: " + str(Global.totalRuns)


func format_time(seconds: float) -> String:
	var hours = int(seconds) / 3600
	var minutes = (int(seconds) % 3600) / 60
	var secs = int(seconds) % 60
	return "%02d:%02d:%02d" % [hours, minutes, secs]

func _on_button_2_pressed() -> void:
	if current_tween and current_tween.is_running():
		current_tween.kill()

	current_tween = create_tween()
	current_tween.tween_property(self, "modulate:a", 0.0, 1.0).from(modulate.a)
	current_tween.tween_callback(self.queue_free)
