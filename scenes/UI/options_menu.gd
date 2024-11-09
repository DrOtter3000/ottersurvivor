extends CanvasLayer

signal back_pressed

@onready var sfx_slider: HSlider = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/VBoxContainer/SFXContainer/SFXSlider
@onready var music_slider: HSlider = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/VBoxContainer/MusicContainer/MusicSlider
@onready var window_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/VBoxContainer/WindowOptionContainer/WindowButton
@onready var vsync_box: CheckBox = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/VBoxContainer/VsyncContainer/VsyncBox


func _ready() -> void:
	sfx_slider.value_changed.connect(on_audio_slider_changed.bind("SFX"))
	music_slider.value_changed.connect(on_audio_slider_changed.bind("Music"))
	update_display()


func update_display():
	window_button.text = "Windowed"
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_button.text = "Fullscreen"
	sfx_slider.value = get_bus_volume_percent("SFX")
	music_slider.value = get_bus_volume_percent("Music")


func get_bus_volume_percent(bus_name: String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)


func set_bus_volume_percent(bus_name: String, percent: float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = linear_to_db(percent)
	AudioServer.set_bus_volume_db(bus_index, volume_db)


func _on_window_button_pressed() -> void:
	var mode = DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	update_display()


func _on_back_button_pressed() -> void:
	back_pressed.emit()


func on_audio_slider_changed(value: float, bus_name: String):
	set_bus_volume_percent(bus_name, value)


func _on_vsync_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
