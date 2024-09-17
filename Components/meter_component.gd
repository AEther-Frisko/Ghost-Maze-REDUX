class_name MeterRechargeComponent
extends Node

@export var actor: CharacterBody3D
@export var meter_stats: MeterStats

func _physics_process(_delta: float) -> void:
	if not is_equal_approx(meter_stats.value, meter_stats.max_value):
		await get_tree().create_timer(meter_stats.value_cooldown).timeout
		meter_stats.value += meter_stats.charge_rate / 10
