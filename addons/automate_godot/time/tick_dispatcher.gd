extends RefCounted
class_name AutomateTickDispatcher

## Single integration point between game time and automation rules, mirroring
## automate-fvtt's tick dispatcher. Elapsed intervals fan out to subscribers
## one interval at a time, so a large jump (a year in one step) resolves
## identically to the same number of single-interval advances. The interval
## unit (day, hour, world-time slice) is the host game's choice.

signal interval_elapsed(interval_index: int)

var intervals_elapsed_total: int = 0

var _subscribers: Dictionary = {}


func subscribe(id: String, callback: Callable) -> void:
	_subscribers[id] = callback


func unsubscribe(id: String) -> void:
	_subscribers.erase(id)


func advance(intervals: int) -> void:
	for _interval in range(max(intervals, 0)):
		intervals_elapsed_total += 1
		for id in _subscribers.keys():
			var callback: Callable = _subscribers[id]
			if callback.is_valid():
				callback.call(intervals_elapsed_total)
		interval_elapsed.emit(intervals_elapsed_total)
