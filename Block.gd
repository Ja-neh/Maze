class_name Block

var b_column : int
var b_row : int
var neighbours : Array
var visitable_neighbours : Array
var num_visits : int  #times an algorithmn has visited a block


func _init(column : int , row : int) -> void:
	b_column = column
	b_row = row
	num_visits = 0


func _add_neighbour(neighbour : Block):
	neighbours.append(neighbour)
	visitable_neighbours.append(neighbour)
