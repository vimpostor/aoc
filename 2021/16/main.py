#!/usr/bin/env python

from functools import reduce

class Ops:
	def product(arr):
		return reduce(lambda x, y: x * y, arr, 1)

	def greater_than(arr):
		return arr[0] > arr[1]

	def less_than(arr):
		return arr[0] < arr[1]

	def equal_to(arr):
		return arr[0] == arr[1]


class Packet:
	def parse(self, code):
		self.subpackets = []
		self.version = int(code[0:3], 2)
		self.type = int(code[3:6], 2)
		head = 6
		if self.type == 4:
			# literal value
			literal_str = ''
			while True:
				literal_str = literal_str + code[head+1:head+5]
				if code[head] == '0':
					break
				head += 5
			self.literal = int(literal_str, 2)
			head += 5
		else:
			# operator packet
			self.is_packetnum = bool(int(code[head]))
			head += 1
			if self.is_packetnum:
				# length is num of sub-packets (11 bits)
				length_bits = 11
			else:
				# length is total length (15 bits)
				length_bits = 15

			self.length = int(code[head:head+length_bits], 2)
			head += length_bits
			subpacket_start = head
			while (self.is_packetnum and len(self.subpackets) < self.length) or (not self.is_packetnum and (head - subpacket_start) < self.length):
				new_p = Packet()
				head += new_p.parse(code[head:])
				self.subpackets.append(new_p)
		return head

	def count(self):
		return self.version + sum(map(Packet.count, self.subpackets))

	def eval(self):
		if self.type == 4:
			return self.literal
		ops = {0: sum, 1: Ops.product, 2: min, 3: max, 5: Ops.greater_than, 6: Ops.less_than, 7: Ops.equal_to}
		return ops[self.type](list(map(Packet.eval, self.subpackets)))


# parse input
code = bin(int('1'+open('input.txt').readlines()[0].strip(), 16))[3:]
root = Packet()
root.parse(code)
# part 1
print(root.count())
# part 2
print(root.eval())
