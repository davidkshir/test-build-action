class_name GameResultsManager
extends Node

signal results_updated

var _results: Array[GameRecord] = []


@rpc("authority", "call_local", "reliable")
func append_record(record_data: Dictionary) -> void:
	var record = GameRecord.new()

	record.loser_id = record_data.get("loser_id")
	record.win_state = record_data.get("win_state")
	record.winner_id = record_data.get("winner_id")

	_results.append(record)
	results_updated.emit()


@rpc("authority", "call_local", "reliable")
func clear() -> void:
	_results.clear()
	results_updated.emit()


func get_recent_results() -> Array[GameRecord]:
	var recent: Array[GameRecord] = []

	for i in range(_results.size() - 1, max(-1, _results.size() - 4), -1):
		recent.append(_results[i])

	return recent
