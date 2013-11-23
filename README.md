rake-compile
============

rake-compile is a set of rake DSL extensions that are useful for building C and C++ projects.  I like rake a lot, but I found that I needed a lot of infrastructure in place to get a full build system going.  This gem just wraps up that functionality.

    # define your source files
    SOURCES = FileList['**/*.cpp']

    # define a directory that will hold build artifacts
    build_directory BUILD_DIR

    # define flags that will apply to all invocations of the default compiler
    base_cpp_flags("-std=c++11 -stdlib=libc++ -I#{File.dirname(__FILE__)}")
    base_cc_flags("-std=c11 -I#{File.dirname(__FILE__)}")

    # define a pre-compiled header, that will be applied to the subsequently-defined target
    pch 'my_prefix_header.pch'

    # define compiler flags that will only apply to the subsequently-defined target
    cpp_flags '-Iinclude'

    # link the target with a library
    link_library '/usr/local/lib/libz.a'

    # define an executable target, and build it by compiling all the sources and linking
    executable 'mybinary' do |target|
      target.add_objects_from_sources SOURCES
    end
