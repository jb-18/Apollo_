class_name Enemy extends Area2D

signal killed(points)

@export var speed = 150
@export var hp = 1
@export var damage = 1
@export var points = 200
func _physics_process(delta):
	global_position.y += speed * delta

func die():
	queue_free()


func _on_body_entered(body):
	if body is Player:
		body.die()
		die()

func take_damage(amount):
	hp -= amount
	if hp <= 0:
		killed.emit(points)
		die()
