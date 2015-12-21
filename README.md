# Cython headers for Google Sparsehash

This library provides Cython `.pxd` files for Google's Sparsehash library. Both `dense_hash_map` and `sparse_hash_map` are implemented. They are useful only when used directly for Cython.

In case you need to use `sparsehash` from Python, there is an incomplete wrapper of `sparse_hash_map` in `class SparseHashMap` which will require setting the C++ template parameters manually. The current version maps `uint32_t` to `uint16_t` as that is what I originally needed. Refer to `test_internal.pyx` for example usage.

## TODO:

* **Add a custom hash function to `SparseHashMap`**
* Benchmark `cdef get` versus `cpdef get`
* Figure out a way to instantiate `SparseHashMap` without setting template parameters manually
* Consider migrating to `serialize/unserialize` of `sparse_hash_map`. The docs [say](https://sparsehash.googlecode.com/svn/trunk/doc/sparse_hash_map.html#io) that it is currently the preferred way to do I/O. However, the only advantage I see is that it is also implemented by `dense_hash_map`, unlike `{read,write}_{metadata,nopointer_data}`.
