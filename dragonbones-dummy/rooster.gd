extends Node2D

# You are gonna need to access the api via the dragonbones node, where the armature is also
@onready var dragonbones :DragonBones = $DragonBones
@onready var _armature :DragonBonesArmature = dragonbones.armature
# This gives us a string list of all the animations
@onready var animations: PackedStringArray = _armature.get_animations()

# also see https://mauville-technologies.github.io/godot_dragonbones_tutorial/
# https://github.com/mauville-technologies/godot_dragonbones_tutorial

var slots = []
var active_slot: DragonBonesSlot
func _ready() -> void:
	# this starts the animation
	dragonbones.active = true
	# this tells it to play any animations at twice the speed
	dragonbones.animation_time_scale = 2
	# This tells it to play the first animation in its list, -1 means play on infinite loop
	_armature.play(animations[0], -1)

	#UI stuff
	for item in _armature.get_animations():
		%AnimationList.add_item(item)
	%AnimationList.select(0)
	_on_animation_list_item_selected(0)
	
	for item in _armature.get_slots():
		# later we can use these slots to change opacity or swap sprites
		var slot = _armature.get_slot(item)
		slots.append(slot)
		%SlotsList.add_item(item)
	_on_slots_list_item_selected(0)

func _on_animation_list_item_selected(index: int) -> void:
	# TODO how do we smootly transition from one animation to another?
	_armature.play(_armature.get_animations()[index], -1)

func _on_slots_list_item_selected(index: int) -> void:
	active_slot = slots[index]
	%SlotSwap.disabled = active_slot.get_display_count() == 1
	%SlotModifier.color = active_slot.get_display_color_multiplier()

func _on_slot_swap_pressed() -> void:
	# If a slot has more than one images, this lets you cycle them
	active_slot.next_display()

func _on_slot_modifier_color_changed(color: Color) -> void:
	if active_slot == null:
		return
	# You can use this to change the alpha of a body part or give it a tint
	active_slot.set_display_color_multiplier(color)
