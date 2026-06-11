extends KinematicBody2D

var speed = 100
var jump = 200
var gravitasi = 10
var velocity = Vector2.ZERO
var sedang_terluka = false

#Rolling
var is_rolling = false
var roll_direction = 1
var facing_direction = 1
var roll_speed = 200
var roll_time = 0.3
var roll_timer = 0

#coin
var coin = 0

#Hp
var is_dead = false
var hp = 5

var is_attacking = false
var attack_offset_x = 14
var attack_offset_y = 6

onready var sprite = $Sprite
onready var HpBar = $"../CanvasLayer/HpBar"
onready var death_menu = $"../CanvasLayer/DeathMenu"
onready var coin_label = $"../CanvasLayer/CoinLabel"

var game_finished = false

func _ready():
	$AttackArea.monitoring = false

func _physics_process(delta):
	if game_finished:
		return
	
	if is_dead:
		return
		
	velocity.y = velocity.y + gravitasi
	
	if !is_rolling:
		if (Input.is_action_pressed("kanan")):
			velocity.x = speed
			facing_direction = 1
		elif (Input.is_action_pressed("kiri")):
			velocity.x = -speed
			facing_direction = -1
		else:
			velocity.x = lerp(velocity.x, 0, 0.2)
	
	$AttackArea.position = Vector2(attack_offset_x * facing_direction, attack_offset_y)
	print("Facing:", facing_direction)
	print("Attack:", $AttackArea.position.x)
	if Input.is_action_just_pressed("Attak") and !is_attacking:
		is_attacking = true
		attack()
	
	if (Input.is_action_just_pressed("roll") and is_on_floor()):
		is_rolling = true
		roll_timer = roll_time
		velocity.x = roll_speed * facing_direction
	
	if is_rolling:
		velocity.x = roll_speed * facing_direction
		roll_timer -= delta
		if roll_timer <= 0:
			is_rolling = false
	
	if (Input.is_action_pressed("jump") and is_on_floor()):
		velocity.y = -jump
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_attacking:
		if sprite.animation == "attack" and sprite.frame == 2:
			$AttackArea.monitoring = true
		else:
			$AttackArea.monitoring = false
	
	if sedang_terluka:
		if sprite.animation != "terluka":
			sprite.play("terluka")
	elif is_attacking:
		if sprite.animation != "attack":
			sprite.play("attack")
	elif is_rolling:
		if sprite.animation != "roll":
			sprite.play("roll")
	else:
		update_animasi()

func update_animasi():
	if is_rolling:
		return
	if abs(velocity.x) < 5:
		sprite.play("idle")
	else:
		sprite.play("run")
	sprite.flip_h = facing_direction < 0

func get_coin():
	coin += 1

	coin_label.text = "Coin : " + str(coin)

	print("Coin :", coin)

func mati():
	print("Player Mati")
	set_physics_process(false)
	sprite.play("mati")
	yield(get_tree().create_timer(0.7), "timeout")
	death_menu.visible = true
	if position.y >1000:
		mati()

func terluka():
	hp -= 1
	HpBar.value = hp
	print("Hp Player: ", hp)
	print("TERLUKA")
	sedang_terluka = true
	if velocity.x > 0:
		velocity.x = -500
	else:
		velocity.x = 500
	yield(get_tree().create_timer(1), "timeout")
	sedang_terluka = false
	
	if hp <= 0:
		is_dead = true
		mati()

func attack():
	is_attacking = true
	sprite.play("attack")
	yield(get_tree().create_timer(0.5), "timeout")
	is_attacking = false

func _on_AttackArea_body_entered(body):
	if body.has_method("kena_hit"):
		body.kena_hit(facing_direction)


