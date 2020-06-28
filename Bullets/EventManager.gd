extends Node

var listeners = {}

func _ready():
	pass

# void listen(string event, funcref callback)
# adds a function reference to the list of listeners for the given named event
func listen(event, callback):
	if not listeners.has(event):
		listeners[event] = []
	listeners[event].append(callback)

# void ignore(string event, funcref callback)
# removes a function reference from the list of listeners for the given named event
func ignore(event, callback):
	if listeners.has(event):
		if listeners[event].find(callback):
			listeners[event].remove(callback)

# void sendEvent(string event, object args)
# calls each callback in the list of callbacks in listeners for the given named event, passing args to each
func sendEvent(event, args):
	if listeners.has(event):
		for callback in listeners[event]:
			callback.call_func(args)

