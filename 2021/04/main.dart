import 'dart:io';

bool is_marked(int v) {
	return v == -1;
}

int boards_sum(List<List<List<int>>> b) {
	return b[0].map((r) => r.where((v) => !is_marked(v)).fold<int>(0, (a, b) => a + b)).reduce((a, b) => a + b);
}

bool board_done(List<List<int>> b) {
	return b.any((r) => r.every(is_marked)) || List.generate(b.length, (i) => List.generate(b.length, (j) => b[j][i])).any((l) => l.every(is_marked));
}

void main() {
	final lines = File('input.txt').readAsLinesSync();
	List<int> numbers = lines[0].split(',').map(int.parse).toList();
	List<List<List<int>>> boards = [];
	for (int i = 2; i < lines.length; i+=6) {
		List<List<int>> board = [];
		for (int j = 0; j < 5; j++) {
			List<int> line = lines[i + j].trim().split(RegExp(r'\s+')).map(int.parse).toList();
			board.add(line);
		}
		boards.add(board);
	}

	int i = 0;
	int num = 0;
	List<List<List<int>>> finished_boards = [];
	bool best_found = false;
	while (finished_boards.length < boards.length) {
		finished_boards.forEach((b) => boards.removeWhere((c) => c == b));

		num = numbers[i];
		boards = boards.map((b) => b.map((r) => r.map((v) => v == num ? -1 : v).toList()).toList()).toList();
		finished_boards = boards.where(board_done).toList();

		// part 1
		if (finished_boards.length > 0 && !best_found) {
			print(num * boards_sum(finished_boards));
			best_found = true;
		}
		i++;
	}

	// part 2
	print(num * boards_sum(finished_boards));
}
