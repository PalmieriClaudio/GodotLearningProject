class_name BulletManager
extends Node

@export var bullet_scene: PackedScene
var bulletPool: Array[Area2D] = []
var activeBullets: Array[Area2D] = []

func _ready():
	for i in range(100):
		var b = bullet_scene.instantiate()
		b.visible = false
		b.active = false
		add_child(b)
		bulletPool.append(b)

func SpawnBullet(pos: Vector2, direction: Vector2, speed: float = 200, color: Color = Color.BLACK, lifetime: float = 5):
	var bullet: Area2D = GetBullet()
	bullet.fire(pos, direction, speed, lifetime, self, color)

func GetBullet() -> Area2D:
	if bulletPool.size() > 0:
		var bullet = bulletPool.pop_back()
		activeBullets.append(bullet)
		return bullet
	else:
		var bullet = bullet_scene.instantiate()
		add_child(bullet)
		activeBullets.append(bullet)
		return bullet

func ReturnBullet(bullet: Area2D):
	bullet.visible = false
	bullet.active = false
	activeBullets.erase(bullet)
	bulletPool.append(bullet)
