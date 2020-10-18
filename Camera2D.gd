extends Camera2D
const base_offset = Vector2 (0 , 40)
func _input(event):
	var mouse = get_viewport().get_mouse_position()
	

	if Input.is_action_pressed("Zoom"):
		var seize = get_viewport().size
		var center = seize / 2
		var center_offset = center - base_offset
		var difference = ((mouse - center_offset) / seize) * 100
		position = difference + base_offset
	else:
		position = base_offset
		
