extends Node


var spawn_points = {
	"1": {
		"pattern1": [Vector3(0, 0, 0)],
		"pattern2": [Vector3(0, 0, 3.5), Vector3(0, 0, -3.5)],
		"pattern3": [Vector3(2.5, 0, 6), Vector3(-2.5, 0, -6)],
		"pattern4": [Vector3(-2.5, 0, 6), Vector3(2.5, 0, -6)],
		"pattern5": [Vector3(2.5, 0, 6.5), Vector3(-2.5, 0, 6.5),Vector3(2.5, 0, -6.5), Vector3(-2.5, 0, -6.5)],
		"pattern6": [Vector3(-2, 0, 4.5), Vector3(-2, 0, -4.5), Vector3(1.5, 0, 0)]
	},
	"2": {
		"pattern1": [Vector3(0, 0, 0)],
		"pattern2": [Vector3(0, 0, 3.5), Vector3(0, 0, -3.5)],
		"pattern3": [Vector3(0, 0, 0),Vector3(0, 0, 3.5), Vector3(0, 0, -3.5)],
		"pattern4": [Vector3(2, 0, 3),Vector3(-2, 0, -3), Vector3(-2, 0, 3),Vector3(2, 0, -3)],
		"pattern5": [Vector3(2, 0, 3),Vector3(-2, 0, -3), Vector3(2, 0, 0)],
	},
	"3": {
		"pattern1": []
	},
	"4": {
		"pattern1": [Vector3(0, 0, 0)],
		"pattern2": [Vector3(0, 0, 2.5), Vector3(0, 0, -2.5)],
		"pattern3": [Vector3(2.5, 0, 6.5), Vector3(-2.5, 0, 6.5),Vector3(2.5, 0, -6.5), Vector3(-2.5, 0, -6.5)],
		"pattern4": [Vector3(-2, 0, 2.5), Vector3(-2, 0, -2.5), Vector3(1.5, 0, 0)]
	},
	"5": {
		"pattern1": [Vector3(0, 0, 0)],
	},
	"6": {
		"pattern1": [Vector3(0, 0, 0)],
		"pattern2": [Vector3(0, 0, 2.5), Vector3(0, 0, -2.5)],
		"pattern3": [Vector3(2.5, 0, 6.5), Vector3(-2.5, 0, 6.5),Vector3(2.5, 0, -6.5), Vector3(-2.5, 0, -6.5)],
	},
	"7": {
		"pattern1": [Vector3(2.5, 0, 6.5), Vector3(-2.5, 0, 6.5),Vector3(2.5, 0, -6.5), Vector3(-2.5, 0, -6.5)],
		"pattern2": [Vector3(3, 0, 3.5), Vector3(-3, 0, 3.5),Vector3(3, 0, -3.5), Vector3(-3, 0, -3.5)],
	},
	"8": {
		"pattern1": [Vector3(0, 0, 0)],
		"pattern2": [Vector3(2.5, 0, 6.5), Vector3(-2.5, 0, 6.5),Vector3(2.5, 0, -6.5), Vector3(-2.5, 0, -6.5)],
		"pattern3": [Vector3(0, 0, 4)],
		"pattern4": [Vector3(2.5, 0, 4),Vector3(-2.5, 0, 4)],
	},
	"9": {
		"pattern1": [Vector3(0, 0, 0)],
		"pattern2": [Vector3(2.5, 0, 6.5), Vector3(-2.5, 0, 6.5),Vector3(2.5, 0, -6.5), Vector3(-2.5, 0, -6.5)],
		"pattern3": [Vector3(0, 0, 3.5),Vector3(0, 0, -3.5)],
		"pattern4": [Vector3(0, 0, 3.5),Vector3(0, 0, -3.5)],
	},
}
