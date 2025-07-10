extends CharacterBody2D

#var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var speed = 500
const MAXSPEED_X = 500
const MAXSPEED_Y = 500

#func _process(delta: float) -> void:

func _physics_process(delta: float) -> void:
	#get input
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	velocity = velocity.normalized() * speed
	self.move_and_slide()
