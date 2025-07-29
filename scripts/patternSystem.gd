class_name PatternSystem
extends Node

var patterns_available := {
	"direct": {
		"speed": 250,
		"color": Color.HOT_PINK,
		"handler": "_fire_direct"
	},
	"circle": {
		"speed": 200,
		"color": Color.DARK_RED,
		"bullet_count": 12,
		"handler": "_fire_circle"
	},
	"spiral": {
		"speed": 150,
		"color": Color.DEEP_SKY_BLUE,
		"bullets_per_shot": 8,
		"tightness": 0.4,
		"handler": "_fire_spiral"
	}
}
var source: Node2D
var target: Node2D

@onready var bullet_manager: Node = $"../../BulletManager"

func initialize(src: Node2D, tgt: Node2D):
	source = src
	target = tgt

func execute_pattern(pattern_name: String, params: Dictionary = {}):
	if not patterns_available.has(pattern_name):
		push_error("Pattern not available: ", pattern_name)
		return
	
	var pattern = patterns_available[pattern_name]
	call(pattern.handler, pattern, params)

func _fire_direct(pattern: Dictionary, _params: Dictionary):
	var dir = (target.global_position - source.global_position).normalized()
	bullet_manager.SpawnBullet(
		source.global_position,
		dir,
		pattern.speed,
		pattern.color
	)

func _fire_circle(pattern: Dictionary, _params: Dictionary):
	for i in range(pattern.bullet_count):
		var angle = i * (TAU / pattern.bullet_count)
		var dir = Vector2.RIGHT.rotated(angle)
		bullet_manager.SpawnBullet(
			source.global_position,
			dir,
			pattern.speed,
			pattern.color
		)

func _fire_spiral(pattern: Dictionary, params: Dictionary):
	for i in range(pattern.bullets_per_shot):
		var angle_offset = pattern.bullets_per_shot * pattern.tightness + i * (TAU / pattern.bullets_per_shot)
		var dir = Vector2.RIGHT.rotated(params.current_angle + angle_offset)
		bullet_manager.SpawnBullet(source.global_position, dir, pattern.speed, pattern.color)
