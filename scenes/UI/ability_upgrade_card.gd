extends PanelContainer

signal selected

@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var description_label: Label = $VBoxContainer/DescriptionLabel

func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		selected.emit()
