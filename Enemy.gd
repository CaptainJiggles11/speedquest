extends Node2D

#Enemy Stats
export (float) var health = 3
export (float) var speed = 50
export (int) var damage = 1

#Enemy States
enum enemy_type {none,zombie,skeleton,swampy}
export (enemy_type) var my_type = enemy_type.none
enum attack_type {none,chase,jump,shoot}
export (attack_type) var my_attack = attack_type.none
var slow = 0

#Enemy Setup
var rb
var sprite
var sfx


# Called when the node enters the scene tree for the first time.
func _ready():
	rb = $RigidBody2D
	sprite = $Sprite
	sfx = $RigidBody2D/EnemyAudio
	
	match my_type:
		enemy_type.none:
			print("non")
		enemy_type.zombie:
			print("zambie")
		enemy_type.skeleton:
			print("skelton")
		enemy_type.swampy:
			print("swarmp")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if health <= 0:
		queue_free()
	
	var actual_speed = speed * slow
	if slow < 1:
		slow+= delta
	
	if position.x > Global.player_position.x:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	match my_attack:
		attack_type.none:
			pass
		attack_type.chase:
			position += (Global.player_position - self.position).normalized() * actual_speed * delta 
		attack_type.jump:
			pass
		attack_type.shoot:
			pass
		
	pass


func _on_RigidBody2D_body_shape_entered(body_id, body, body_shape, local_shape):
	if body.name == "WeaponBody":
		sprite.modulate = Color(1,0,0)
		print("hit")
		yield(get_tree().create_timer(.1), "timeout")
		sprite.modulate = Color(1,1,1)
		position -= (Global.player_position - self.position).normalized() * 3
		slow = .75
		take_damage(body.attack_damage)
	pass # Replace with function body.
	
func take_damage(damage_dealt):
	sfx.play_sound(sfx.hitsounds)
	health-=damage_dealt
	print(health)
