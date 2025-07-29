class_name ExtendedCamera2D
extends Camera2D

func is_position_in_view(world_position: Vector2, margin: float = 100.0) -> bool:
	var canvas_transform = get_viewport().get_canvas_transform()
	var screen_pos = canvas_transform * world_position
	var viewport_rect = Rect2(Vector2.ZERO, get_viewport().size)
	
	var result = viewport_rect.grow(margin).has_point(screen_pos)
	return result
