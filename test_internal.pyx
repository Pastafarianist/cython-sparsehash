from sparsehash cimport dense_hash_map, sparse_hash_map, SparseHashMap
from libc.stdint cimport uint32_t, uint16_t
import random

MAX_UINT16 = 0xFFFF
MAX_UINT32 = 0xFFFFFFFF


def test_dense():
	cdef dense_hash_map[uint32_t, uint16_t] m_dense
	print('Testing dense_hash_map.')
	m_dense.set_empty_key(MAX_UINT32)
	key = random.randint(0, MAX_UINT32 - 1)
	value = random.randint(0, MAX_UINT16)
	print('Generated key: %d, value: %d' % (key, value))
	m_dense[key] = value
	print('At key %d map contains: %d' % (key, m_dense[key]))
	assert m_dense[key] == value, m_dense[key]
	nonexistent_key = (key + 1) % (MAX_UINT32 - 1)
	print('At key %d map contains: %d' % (nonexistent_key, m_dense[nonexistent_key]))
	print('-' * 60)

def test_sparse():
	cdef sparse_hash_map[uint32_t, uint16_t] m_sparse
	print('Testing sparse_hash_map.')

	print('empty(): %r' % m_sparse.empty())
	print('size(): %r' % m_sparse.size())
	print('max_size(): %r' % m_sparse.max_size())

	key = random.randint(0, MAX_UINT32)
	value = random.randint(0, MAX_UINT16)
	print('Generated key: %d, value: %d' % (key, value))
	print('count(%d): %r' % (key, m_sparse.count(key)))
	print('find(%d) == end(): %r' % (key, m_sparse.find(key) == m_sparse.end()))
	m_sparse[key] = value
	print('At key %d map contains: %d' % (key, m_sparse[key]))
	assert m_sparse[key] == value, m_sparse[key]
	print('size(): %r' % m_sparse.size())
	assert m_sparse.size() == 1, m_sparse.size()
	print('count(%d): %r' % (key, m_sparse.count(key)))
	assert m_sparse.count(key) == 1, m_sparse.count(key)
	print('find(%d) == end(): %r' % (key, m_sparse.find(key) == m_sparse.end()))
	assert m_sparse.find(key) != m_sparse.end()

	nonexistent_key = (key + 1) % MAX_UINT32
	print('At key %d map contains: %d' % (nonexistent_key, m_sparse[nonexistent_key]))
	assert m_sparse[nonexistent_key] == 0, m_sparse[nonexistent_key]
	print('size(): %r' % m_sparse.size())
	assert m_sparse.size() == 2, m_sparse.size()
	print('count(%d): %r' % (nonexistent_key, m_sparse.count(nonexistent_key)))
	assert m_sparse.count(nonexistent_key) == 1, m_sparse.count(nonexistent_key)

	print('bucket_count(): %r' % m_sparse.bucket_count())
	print('-' * 60)


def test_class():
	print("Testing SparseHashMap.")
	m = SparseHashMap()
	print('len(): %d' % len(m))
	assert len(m) == 0, len(m)
	m[1] = 2
	print('len(): %d' % len(m))
	assert len(m) == 1, len(m)
	print('__repr__(): %r' % (m, ))
	assert 1 in m
	assert 8 not in m
	with open('table.dat', 'wb') as f:
		m.save(f)
	
	del m

	with open('table.dat', 'rb') as f:
		m = SparseHashMap(f)

	assert len(m) == 1, len(m)
	assert 1 in m
	assert 8 not in m
	print('-' * 60)


def test_sequential_pass():
	m = SparseHashMap()
	N = 30

	for i in range(N):
		m[random.randint(0, 99)] = random.randint(0, MAX_UINT16)

	print(', '.join(str(elem) for elem in m.keys()))
	print(', '.join(str(elem) for elem in m.ordered_keys()))

	original_keys = list(m.keys())
	ordered_keys = list(m.ordered_keys())

	assert sorted(original_keys) == ordered_keys

	print('-' * 60)

def test_get():
	m = SparseHashMap()

	N = 30
	MAX = 100

	d = {random.randint(0, MAX) : random.randint(1, MAX_UINT16) for _ in range(N)}

	for k, v in d.items():
		m[k] = v

	for i in range(MAX):
		v = m.get(i, 0)
		if v == 0:
			assert i not in d
		else:
			assert v == d[i]

def main():
	test_dense()
	test_sparse()
	test_class()
	test_sequential_pass()
	test_get()
