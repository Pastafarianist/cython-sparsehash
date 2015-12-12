from libcpp.utility cimport pair
from libc.stdint cimport uint64_t, uint32_t, uint16_t
from libc.stdio cimport FILE


cdef extern from "sparsehash/dense_hash_map" namespace "google":
    cdef cppclass dense_hash_map[K, D]:
        K& key_type
        D& data_type
        pair[K, D]& value_type
        uint64_t size_type
        cppclass iterator:
            pair[K, D]& operator*() nogil
            iterator operator++() nogil
            iterator operator--() nogil
            bint operator==(iterator) nogil
            bint operator!=(iterator) nogil
        iterator begin()
        iterator end()
        uint64_t size()
        uint64_t max_size()
        bint empty()
        uint64_t bucket_count()
        uint64_t bucket_size(uint64_t i)
        uint64_t bucket(K& key)
        double max_load_factor()
        void max_load_vactor(double new_grow)
        double min_load_factor()
        double min_load_factor(double new_grow)
        void set_resizing_parameters(double shrink, double grow)
        void resize(uint64_t n)
        void rehash(uint64_t n)
        dense_hash_map()
        dense_hash_map(uint64_t n)
        void swap(dense_hash_map&)
        pair[iterator, bint] insert(pair[K, D]) nogil
        void set_empty_key(K&)
        void set_deleted_key(K& key)
        void clear_deleted_key()
        void erase(iterator pos)
        uint64_t erase(K& k)
        void erase(iterator first, iterator last)
        void clear()
        void clear_no_resize()
        pair[iterator, iterator] equal_range(K& k)
        D& operator[](K&) nogil


cdef extern from "sparsehash/sparse_hash_map" namespace "google":
    cdef cppclass sparse_hash_map[K, D]:
        K& key_type
        D& data_type
        pair[K, D]& value_type
        uint64_t size_type
        cppclass iterator:
            pair[K, D]& operator*() nogil
            iterator operator++() nogil
            iterator operator--() nogil
            bint operator==(iterator) nogil
            bint operator!=(iterator) nogil
        iterator begin()
        iterator end()
        uint64_t size()
        uint64_t max_size()
        bint empty()
        uint64_t bucket_count()
        uint64_t bucket_size(uint64_t i)
        uint64_t bucket(K& key)
        double max_load_factor()
        void max_load_vactor(double new_grow)
        double min_load_factor()
        double min_load_factor(double new_grow)
        void set_resizing_parameters(double shrink, double grow)
        void resize(uint64_t n)
        void rehash(uint64_t n)
        sparse_hash_map()
        sparse_hash_map(uint64_t n)
        void swap(sparse_hash_map&)
        pair[iterator, bint] insert(pair[K, D]) nogil
        void set_deleted_key(K& key)
        void clear_deleted_key()
        void erase(iterator pos)
        uint64_t erase(K& k)
        void erase(iterator first, iterator last)
        void clear()
        void clear_no_resize()
        pair[iterator, iterator] equal_range(K& k)
        D& operator[](K&) nogil
        uint64_t count(K& k)
        iterator find(K& k)
        bint write_metadata(FILE *fp)
        bint read_metadata(FILE *fp)
        bint write_nopointer_data(FILE *fp)
        bint read_nopointer_data(FILE *fp)


cdef class SparseHashMap:
    cdef sparse_hash_map[uint32_t, uint16_t]* thisptr

    # No need to define methods here.

    # def __cinit__(self)
    # def __dealloc__(self)
    # def __bool__(self)
    # def __len__(self)
    # def __contains__(self, uint32_t item)
    # def __getitem__(self, uint32_t key)
    # def get(self, uint32_t key, uint16_t default=0)
    # def __setitem__(self, uint32_t key, uint16_t value)
    # def clear(self)
    # def __iter__(self)
    # def keys(self)
    # def items(self)
    # def values(self)
    # def load(self, f)
    # def save(self, f)
    # def __str__(self)
    # def __repr__(self)