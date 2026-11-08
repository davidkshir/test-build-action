class_name GameResultsManager
extends Node

var _results: Array[GameRecord] = []


@rpc("authority", "call_local", "reliable")
func append_record(record_data: Dictionary) -> void:
	var record = GameRecord.new()

	record.loser_id = record_data.get("loser_id")
	record.win_state = record_data.get("win_state")
	record.winner_id = record_data.get("winner_id")

	_results.append(record)


@rpc("authority", "call_local", "reliable")
func clear() -> void:
	_results.clear()
