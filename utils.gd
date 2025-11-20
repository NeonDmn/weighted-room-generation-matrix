class_name Utils

static func clear_children(node: Control):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
