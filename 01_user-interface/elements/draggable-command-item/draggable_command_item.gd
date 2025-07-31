# First, create a new class for draggable command items
class_name DraggableCommandItem extends Control

var command: BaseCommand
var original_index: int
var is_dragging: bool = false
var drag_offset: Vector2
var original_position: Vector2

signal item_dropped(from_index: int, to_index: int)
signal item_deleted(index: int)

func _init(cmd: BaseCommand, index: int):
	command = cmd
	original_index = index
	custom_minimum_size = Vector2(200, 30)  # Set a minimum size
	
	# Create the visual elements
	setup_ui()

func setup_ui():
	# Create HBox container
	var hbox = HBoxContainer.new()
	hbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	# Create label
	var label = Label.new()
	label.text = str(original_index + 1, ": ", command.cmdName)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	# Make label font smaller
	var label_theme = Theme.new()
	label_theme.set_font_size("font_size", "Label", 10)
	label.theme = label_theme
	
	# Create delete button
	var delete_btn = Button.new()
	delete_btn.text = "X"
	delete_btn.custom_minimum_size = Vector2(20, 20)
	delete_btn.pressed.connect(_on_delete_pressed)
	
	# Make button font smaller
	var btn_theme = Theme.new()
	btn_theme.set_font_size("font_size", "Button", 8)
	delete_btn.theme = btn_theme
	
	# Add to HBox
	hbox.add_child(label)
	hbox.add_child(delete_btn)
	add_child(hbox)
	
	# Add visual feedback for dragging
	var panel = Panel.new()
	panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(panel)
	move_child(panel, 0)  # Put panel behind other elements

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Start dragging
				is_dragging = true
				drag_offset = event.position
				original_position = global_position
				z_index = 100  # Bring to front while dragging
				modulate = Color(1, 1, 1, 0.8)  # Make slightly transparent
			else:
				# Stop dragging
				if is_dragging:
					_handle_drop()
				is_dragging = false
				z_index = 0
				modulate = Color.WHITE
	
	elif event is InputEventMouseMotion and is_dragging:
		# Move the item while dragging
		global_position = get_global_mouse_position() - drag_offset

func _handle_drop():
	# Find which position this item should be dropped at
	var parent_container = get_parent()
	if not parent_container:
		return
	
	var drop_index = _calculate_drop_index()
	
	if drop_index != original_index and drop_index >= 0:
		item_dropped.emit(original_index, drop_index)
	else:
		# Snap back to original position if no valid drop
		global_position = original_position

func _calculate_drop_index() -> int:
	var parent_container = get_parent()
	var children = parent_container.get_children()
	var mouse_y = get_global_mouse_position().y
	
	# Find where to insert based on mouse Y position
	for i in range(children.size()):
		var child = children[i]
		if child == self:
			continue
		
		var child_center_y = child.global_position.y + child.size.y / 2
		if mouse_y < child_center_y:
			return i
	
	# If we're below all items, insert at the end
	return children.size() - 1

func _on_delete_pressed():
	item_deleted.emit(original_index)
