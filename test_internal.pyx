from sparsehash cimport dense_hash_map, sparse_hash_map
from libc.stdint cimport uint32_t, uint16_t

import unittest
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
	assert m_dense[key] == value
	nonexistent_key = (key + 1) % (MAX_UINT32 - 1)
	print('At key %d map contains: %d' % (nonexistent_key, m_dense[nonexistent_key]))

def test_sparse():
	cdef sparse_hash_map[uint32_t, uint16_t] m_sparse
	print('Testing dense_hash_map.')
	key = random.randint(0, MAX_UINT32)
	value = random.randint(0, MAX_UINT16)
	print('Generated key: %d, value: %d' % (key, value))
	m_sparse[key] = value
	print('At key %d map contains: %d' % (key, m_sparse[key]))
	assert m_sparse[key] == value
	nonexistent_key = (key + 1) % MAX_UINT32
	print('At key %d map contains: %d' % (nonexistent_key, m_sparse[nonexistent_key]))

test_dense()
test_sparse()
