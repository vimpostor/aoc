import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

ApplicationWindow {
	property string content: ""
	visible: true
	width: 485
	height: 300
	Material.theme: Material.System
	function step(arr) {
		arr.forEach(function(p, i) {
			var item = arr[i];
			item.x += item.vx;
			item.y += item.vy;
			item.vx = Math.max(0, item.vx - 1);
			item.vy -= 1;
			arr[i] = item;
		});
	}
	function solve() {
		// parsing
		const ax = content.split(',');
		const xmin = Number(ax[0].split("..")[0].split('=')[1]);
		const xmax = Number(ax[0].split("..")[1]);
		const ymin = Number(ax[1].split("..")[0].split('=')[1]);
		const ymax = Number(ax[1].split("..")[1]);

		// part 1
		console.log(ymin * (ymin + 1) / 2);

		// part 2
		var candidates = [];
		var solutions = [];
		for (var xvel = 0; xvel <= xmax; xvel++) {
			for (var yvel = ymin; yvel < 1000; yvel++) {
				candidates.push({x: 0, y: 0, vx: xvel, vy: yvel});
			}
		}
		var inside = function(item) {
			return item.x >= xmin && item.x <= xmax && item.y >= ymin && item.y <= ymax;
		};
		while (candidates.length) {
			solutions = solutions.concat(candidates.filter(inside));
			candidates = candidates.filter(function(item) {
				return !inside(item) && item.y >= ymin && item.x <= xmax;
			});
			step(candidates);
		}
		console.log(solutions.length);

	}
	Timer {
		id: solveTimer
		interval: 50
		onTriggered: solve();
	}
	Component.onCompleted: {
		// read file
		var xhr = new XMLHttpRequest;
		xhr.open("GET", "input.txt");
		xhr.onreadystatechange = function() {
			var resp = xhr.responseText;
			content = resp.split('\n')[0];
		}
		xhr.send();
	}
	onContentChanged: {
		solveTimer.start();
	}
}
