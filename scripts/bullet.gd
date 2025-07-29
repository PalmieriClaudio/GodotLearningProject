extends Area2D

@onready var collision_shape_2d = $CollisionShape2D

var velocity: Vector2 = Vector2.ZERO
var speed: float = 200.0
var lifetime: float = 5.0
var age: float = 0.0
var active: bool = false
var bulletManager: Node = null
var bulletColor: Color = Color.BLACK

func _process(delta):
	if not active:
		return

	var camera: ExtendedCamera2D = get_viewport().get_camera_2d()
	
	position += velocity * speed * delta
	age += delta
	if age > lifetime or (camera and not camera.is_position_in_view(global_position, 500)):
		bulletManager.ReturnBullet(self)
		
func _draw():
	var radius = collision_shape_2d.shape.radius
	draw_circle(Vector2.ZERO, radius, bulletColor)

func fire(pos: Vector2, direction: Vector2, speed_value: float = 200.0, lifetime_value: float = 5.0, manager: Node = null, color: Color = Color.DARK_RED):
	bulletManager = manager
	bulletColor = color
	position = pos
	velocity = direction.normalized()
	speed = speed_value
	lifetime = lifetime_value
	age = 0
	active = true
	show()
