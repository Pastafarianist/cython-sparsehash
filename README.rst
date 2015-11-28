====================================
Cython headers for Google Sparsehash
====================================

This library provides Cython .pxd files for Google's Sparsehash library. 
Both `dense_hash_map` and `sparse_hash_map` are implemented.

As yet it's only intended for use directly from Cython. I doubt it'll be of any use
to pure Python programs — the built-in `dict` is better.
