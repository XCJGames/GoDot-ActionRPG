extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

var invincible = false setget set_invincible

onready var timer = $Timer
onready var collisionShape = $CollisionShape2D

signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")
		
func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position


func _on_Timer_timeout():
	self.invincible = false

# we have to use deferred because monitorable can't be changed during physics
# comments said monitoring is more appropriate, check description in editor
# monitorable/monitoring doesn't make the player truly invincible when attacked by 2+
# enemies, so we disable the collisionShape2D of the Hurtbox to prevent damage
func _on_Hurtbox_invincibility_started():
#	set_deferred("monitorable", false)
#	set_deferred("monitoring", false)
	collisionShape.set_deferred("disabled", true)

# this one is signaled by the timer, so it's done after physics
func _on_Hurtbox_invincibility_ended():
#	monitorable = true
#	monitoring = true
	collisionShape.disabled = false
