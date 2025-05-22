extends CanvasLayer

@onready var slider_master = $HSlider_Master
@onready var slider_music = $HSlider_Music
@onready var slider_sfx = $HSlider_SFX

func _ready():
	# Inicializar sliders desde Config
	slider_master.value = Config.master
	slider_music.value = Config.music
	slider_sfx.value = Config.sfx

	# Aplicar valores a los buses de audio
	_set_bus_volume("Master", Config.master)
	_set_bus_volume("Music", Config.music)
	_set_bus_volume("SFX", Config.sfx)

	# Conectar señales
	slider_master.connect("value_changed", _on_master_slider_changed)
	slider_music.connect("value_changed", _on_music_slider_changed)
	slider_sfx.connect("value_changed", _on_sfx_slider_changed)

func _set_bus_volume(bus_name: String, value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), db)

func _on_master_slider_changed(value: float) -> void:
	Config.master = value
	_set_bus_volume("Master", value)

func _on_music_slider_changed(value: float) -> void:
	Config.music = value
	_set_bus_volume("Music", value)

func _on_sfx_slider_changed(value: float) -> void:
	Config.sfx = value
	_set_bus_volume("SFX", value)

func _on_button_pressed() -> void:
	SaveSystem.save_config()
	queue_free()
