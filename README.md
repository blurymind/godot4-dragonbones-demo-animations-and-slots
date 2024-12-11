# godot4-dragonbones-demo-animations-and-slots
A small demo project i did while exploring godot's dragonbones addon
![image](https://github.com/user-attachments/assets/9c82adf0-bc22-4ebe-82eb-2681ec632093)


To try it out, clone this project, open it in Godot, open assetlib and install Godot-DragonBones (https://github.com/Daylily-Zeleen/Godot-DragonBones)
![image](https://github.com/user-attachments/assets/8be79b03-3d43-44f5-b61f-1b2dbc628cd0)
Download it and restart Godot. If you used AssetLib, you shouldn't have to build the addon - there are pre-built targets

Basic Usage example:
```gdscript
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
```
This demo shows how to initialise an animation, get a list of all existing animations, control animation speed, get a list of all existing slots (body parts), swap slot sprites, apply color modifier (like changing opacity, etc)

Other demo repos:
https://github.com/mauville-technologies/godot_dragonbones
https://mauville-technologies.github.io/godot_dragonbones_tutorial/
