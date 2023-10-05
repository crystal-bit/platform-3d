extends Node


var _current_coin_count: int = 0
var _total_coin_count: int = 0


signal state_updated


func add_coin_to_count(quantity: int = 1):
	_total_coin_count += quantity


func current_coin_amount():
	return _current_coin_count


func player_got_coin():
	_current_coin_count += 1
	emit_signal("state_updated")


func reset_state():
	_current_coin_count = 0
	_total_coin_count = 0


func total_coin_amount():
	return _total_coin_count
