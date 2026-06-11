extends KinematicBody2D

var gravitasi = 10
var speed = 10
var velocity = Vector2.ZERO
export var direction = 1

#Knockback
var is_knockback = false
var knockback_power = 500
var knockback_time = 0.1
var knockback_timer = 0

#Hp
var is_dead = false
var hp = 3

func _ready():
	pass

func _physics_process(delta):
	velocity.y += gravitasi
	
	if is_knockback:
		knockback_timer -= delta
		velocity.x = lerp(velocity.x, 0, 0.1)
		if knockback_timer <= 0:
			is_knockback = false
			velocity.x = 0
	else:
		if is_on_wall():
			direction = direction * -1
	
		velocity.x = direction * speed
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	_update_animasi()

func _update_animasi():
	if is_on_floor():
		$AnimatedSprite.play("idle")
	
	$AnimatedSprite.flip_h = true
	if direction == 1:
		$AnimatedSprite.flip_h = false

func _on_Area2D_body_entered(body):
	if body.name == 'Player' and !body.sedang_terluka:
		body.terluka()

func mati():
	if is_dead:
		return
	is_dead = true
	print("MUSUH MATI")
	velocity = Vector2.ZERO
	$AnimatedSprite.play("dead")
	yield(get_tree().create_timer(0.3), "timeout")
	queue_free()

func kena_hit(dari_arah):
	is_knockback = true
	knockback_timer = knockback_time
	velocity.x = knockback_power * dari_arah
	$AnimatedSprite.modulate = Color(1, 0.3, 0.3)
	yield(get_tree().create_timer(0.1), "timeout")
	$AnimatedSprite.modulate = Color(1, 1, 1)
	
	hp -= 1
	print("Hp Musuh: ", hp)
	if hp <= 0:
		mati()
