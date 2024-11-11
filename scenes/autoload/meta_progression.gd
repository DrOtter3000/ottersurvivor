extends Node

const SAVE_FILE_PATH = "user://game.save"
const SAVE_SETTINGS_PATH = "user://settings.save"

var save_data: Dictionary = {
	"clams": 0,
	"meta_upgrades": {}
}

var save_setting_values: Dictionary = {
	"SFX": .75,
	"Music": .75,
	"vsync": false,
	"fullscreen": true
}


func _ready() -> void:
	GameEvents.clam_collected.connect(on_clam_collected)
	load_save_file()
	load_settings()


func load_save_file():
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		return
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	save_data = file.get_var()


func load_settings():
	if !FileAccess.file_exists(SAVE_SETTINGS_PATH):
		return
	var file = FileAccess.open(SAVE_SETTINGS_PATH, FileAccess.READ)
	save_setting_values = file.get_var()
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(save_setting_values["SFX"]))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(save_setting_values["Music"]))


func upgrade_settings():
	if MetaProgression.save_setting_values["vsync"] == true:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(save_setting_values["SFX"]))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(save_setting_values["Music"]))


func save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)


func add_meta_upgrade(upgrade: MetaUpgrade):
	if not save_data["meta_upgrades"].has(upgrade.id):
		save_data["meta_upgrades"][upgrade.id] = {
			"quantity": 0
		}
	
	save_data["meta_upgrades"][upgrade.id]["quantity"] += 1
	save()


func save_settings() -> void:
	var file = FileAccess.open(SAVE_SETTINGS_PATH, FileAccess.WRITE)
	file.store_var(save_setting_values)


func get_upgrade_count(upgrade_id: String):
	if save_data["meta_upgrades"].has(upgrade_id):
		return save_data["meta_upgrades"][upgrade_id]["quantity"]
	return 0


func on_clam_collected(number: float):
	save_data["clams"] += number
