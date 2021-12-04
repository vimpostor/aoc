#include <fstream>
#include <iostream>
#include <cmath>
#include <ranges>
#include <vector>
#include <numeric>

int bin_to_dec(const std::string& b) {
	int power = 0;
	int result = 0;
	for (auto i : b | std::views::reverse) {
		result += (i == '1') * std::pow(2, power);
		++power;
	}
	return result;
}

bool bit_precedence(const std::vector<std::string>& b, const size_t i) {
	return std::accumulate(b.cbegin(), b.cend(), 0, [&](auto a, auto b){ return a + (b[i] == '1'); }) >= b.size() / 2.f;
}

std::vector<std::string> filter(const std::vector<std::string>& a, const size_t i, const bool invert = false) {
	if (a.size() <= 1) {
		return a;
	}
	std::vector<std::string> result;
	const bool g = bit_precedence(a, i) ^ invert;
	std::copy_if(a.begin(), a.end(), std::back_inserter(result), [&](auto s){ return s[i] == (g ? '1' : '0'); });
	return result;
}

char get(const bool b) {
	return b ? '1' : '0';
}

int main()
{
	std::ifstream file("input.txt");
	std::vector<std::string> lines;
	std::string line;
	while (std::getline(file, line)) {
		lines.push_back(line);
	}

	std::string gamma;
	std::string epsilon;
	std::vector<std::string> oxygen = lines;
	std::vector<std::string> co_2 = lines;
	for (size_t i = 0; i < lines.front().size(); ++i) {
		const bool g = bit_precedence(lines, i);
		gamma.push_back(get(g));
		epsilon.push_back(get(!g));
		oxygen = filter(oxygen, i);
		co_2 = filter(co_2, i, true);
	}

	// part 1
	const auto power_consumption = bin_to_dec(gamma) * bin_to_dec(epsilon);
	std::cout << power_consumption << std::endl;

	// part 2
	const auto life_support = bin_to_dec(oxygen.front()) * bin_to_dec(co_2.front());
	std::cout << life_support << std::endl;
}
