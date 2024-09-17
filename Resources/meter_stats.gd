class_name MeterStats
extends Resource

@export var max_value: float = 100
@export var value: float = 100: 
	set(v):
		value = v
		value = clamp(value, 0, max_value)
		value_changed.emit(value)
		if is_zero_approx(value):
			meter_empty.emit()
		if is_equal_approx(value, max_value):
			meter_full.emit()
@export var charge_rate: float = 2.0
@export var value_cooldown: float = 2.5

signal value_changed(new_value)
signal meter_empty()
signal meter_full()
