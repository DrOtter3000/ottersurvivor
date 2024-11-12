extends PanelContainer

@onready var name_label: Label = $MarginContainer/VBoxContainer/PanelContainer/NameLabel
@onready var description_label: Label = $MarginContainer/VBoxContainer/DescriptionLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var purchase_button: Button = $MarginContainer/VBoxContainer/PurchaseButton
@onready var count_label: Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/CountLabel
@onready var progress_label: Label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/ProgressLabel
@onready var clam_texture: TextureRect = $MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/Control/ClamTexture


var upgrade: MetaUpgrade


func select_card() -> void:
	animation_player.play("selected")


func set_meta_upgrade(upgrade: MetaUpgrade):
	self.upgrade = upgrade
	name_label.text = upgrade.title
	description_label.text = upgrade.description
	update_progress()


func update_progress():
	var current_quantity = 0
	if MetaProgression.save_data["meta_upgrades"].has(upgrade.id):
		current_quantity = MetaProgression.save_data["meta_upgrades"][upgrade.id]["quantity"]
		
	var currency = MetaProgression.save_data["clams"]
	var percent = MetaProgression.save_data["clams"] / upgrade.clam_cost
	var is_maxed = current_quantity >= upgrade.max_quantity
	percent = min(percent, 1)
	progress_bar.value = percent
	purchase_button.disabled = percent < 1 || is_maxed
	if is_maxed:
		purchase_button.text = "max"
		progress_label.visible = false
		progress_bar.visible = false
		clam_texture.visible = false
	progress_label.text = str(currency) + "/" + str(upgrade.clam_cost)
	count_label.text = str(current_quantity) + "/" + str(upgrade.max_quantity)


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		select_card()


func _on_purchase_button_pressed() -> void:
	if upgrade == null:
		return
	
	MetaProgression.add_meta_upgrade(upgrade)
	MetaProgression.save_data["clams"] -= upgrade.clam_cost
	MetaProgression.save()
	get_tree().call_group("meta_upgrade_card", "update_progress")
	animation_player.play("selected")
