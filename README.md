rake-compile
============

rake-compile is a set of rake DSL extensions that are useful for building C and C++ projects.  I like rake a lot, but I found that I needed a lot of infrastructure in place to get a full build system going.  This gem just wraps up that functionality.

Features:

- Automatic source dependency calculation
- Dependency caching for faster rake invocations
- PCH file support
- Parallel building using rake's -j option
- automatic clean and clobber

Functions:

    # This is just a like a FileTask, but it invokes all of its prerequisites in parallel
    multifile

    # These methods apply to all targets defined, useful for setting up your build environment
    build_directory <path>
    base_cc_flags <flags>
    base_cpp_flags <flags>

    # These methods apply only to the next target defined, similar to desc for tasks
    cc_flags <flags>
    cpp_flags <flags>
    link_library <path>
    pch <path>

    # These two methods define a build target.  They take a block that allows you to specify the
    # object files that make up the final artifact
    static_library <path>
    executable <path>

Here's a simple example that shows how the DSL is used.

    # define your source files
    SOURCES = FileList['**/*.cpp']

    # define a directory that will hold build artifacts
    build_directory BUILD_DIR

    # define flags that will apply to all invocations of the default compiler
    base_cpp_flags("-std=c++11 -I#{File.dirname(__FILE__)}")
    base_cc_flags("-std=c11 -I#{File.dirname(__FILE__)}")

    # define a pre-compiled header, that will be applied to the subsequently-defined target
    pch 'my_prefix_header.pch'

    # define compiler flags that will only apply to the subsequently-defined target
    cpp_flags '-Iinclude'

    # link the target with a library
    link_library '/usr/local/lib/libz.a'

    # define an executable target, and build it by compiling all the sources and linking
    executable 'mybinary' do |target|
      # you can add objects via a FileList directory
      target.add_objects_from_sources SOURCES

      # or, for one source file at a time
      target.add_object_from_source 'my_source.cpp'

      # or create a direct mapping from source to object
      target.add_object 'my_obj.o', 'special_source.cpp'
    end
