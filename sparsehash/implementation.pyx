from libc.stdint cimport uint32_t, uint16_t
from libc.stdio cimport FILE, fdopen, fflush
from libcpp.vector cimport vector
from libcpp.algorithm cimport sort
from cython.operator cimport dereference as deref

# TODO: is it possible to write this wrapper once and then
# use C++-style tempates in Cython code?
cdef class SparseHashMap:
    ## This field is declared in .pxd:
    # cdef sparse_hash_map[uint32_t, uint16_t]* thisptr

    def __cinit__(self, f=None):
        self.thisptr = new sparse_hash_map[uint32_t, uint16_t]()

    def __init__(self, f=None):
        if f is not None:
            self.load(f)
    
    def __dealloc__(self):
        del self.thisptr
        self.thisptr = <sparse_hash_map[uint32_t, uint16_t]*> NULL
    
    def __bool__(self):
        return self.thisptr.empty()
    
    def __len__(self):
        return self.thisptr.size()
    
    def __contains__(self, uint32_t item):
        # According to a benchmark, count() is marginally faster than
        # find() == end(). It takes about 0.20 seconds to perform
        # 1 000 000 random lookups in a hashtable populated with
        # 1 000 000 random items when using count(). With find() == end(),
        # the runtime is 0.22 seconds on average.
        #
        # According to a t-test performed on the results of the benchmark,
        # the hypothesis that count() is on average faster is false
        # with probability around 6.5%.
        return self.thisptr.count(item) > 0
    
    def __getitem__(self, uint32_t key):
        # I am NOT raising KeyError, because I am optimizing for speed.
        return deref(self.thisptr)[key]
    
    cdef uint16_t get(self, uint32_t key, uint16_t default=0):
        # `default` is 0 instead of None because I have to return uint16_t.
        # Here I am using find() instead of count() && lookup because
        # it allows to retrieve the item in a single query.
        cdef sparse_hash_map[uint32_t, uint16_t].iterator it

        it = self.thisptr.find(key)
        if it != self.thisptr.end():
            return deref(it).second
        else:
            return default
    
    def __setitem__(self, uint32_t key, uint16_t value):
        deref(self.thisptr)[key] = value
    
    # According to the docs, the implementation uses a dedicated
    # key to designate a deleted entry. Therefore, before any calls
    # to `__delitem__` the user should call `set_deleted_key`. I don't
    # need `del`, so I won't bother.
    
    # def __delitem__(self, uint32_t key):
    #     # TODO: I also need to propagate the exception if the key isn't found.
    #     self.thisptr.erase(key)

    def clear(self):
        self.thisptr.clear()
    
    def __iter__(self):
        for pair in deref(self.thisptr):
            key, value = pair.first, pair.second
            yield key
    
    def keys(self):
        return iter(self)

    def items(self):
        for pair in deref(self.thisptr):
            key, value = pair.first, pair.second
            yield key, value

    def values(self):
        for pair in deref(self.thisptr):
            key, value = pair.first, pair.second
            yield value

    def ordered_keys(self):
        cdef vector[uint32_t] v

        for key in self:
            v.push_back(key)

        sort(v.begin(), v.end())

        for key in v:
            yield key
    
    def load(self, f):
        # This replaces the contents of the current hashmap.
        # However, the constructor accepts an optional argument
        # which can be passed to this method.

        cdef FILE* cfile

        cfile = fdopen(f.fileno(), 'rb')
    
        self.thisptr.read_metadata(cfile)
        self.thisptr.read_nopointer_data(cfile)

        # Note: an alternative is to accept a file path as an argument
        # and open it with fopen() right here. Example:
        #     cdef bytes bfile_path = file_path.encode('utf-8')
        #     f = fopen(bfile_path, 'rb')
        #     try:
        #         <read file like above>
        #     finally:
        #         fclose(f)

    def save(self, f):
        cdef FILE* cfile
    
        cfile = fdopen(f.fileno(), 'wb')

        self.thisptr.write_metadata(cfile)
        self.thisptr.write_nopointer_data(cfile)

        fflush(cfile)

        # The note from load() applies here as well, with one
        # adjustment: the file mode has to be 'wb'.

    def __str__(self):
        return '{%s}' % ', '.join('%s: %s' % item for item in self.items())

    def __repr__(self):
        return '{%s}' % ', '.join('%r: %r' % item for item in self.items())

    # TODO: is it possible to define __sizeof__ here?
    # def __sizeof__