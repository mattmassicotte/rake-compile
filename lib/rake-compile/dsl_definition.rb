require_relative 'target'
require_relative 'application'

require 'rake/clean'

module RakeCompile
  module DSL
    def build_directory(dir)
      directory dir
      RakeCompile::Application.app.build_directory = dir
    end

    def base_cc_flags(flags)
      RakeCompile::Application.app.base_cc_flags = flags
    end

    def cc_flags(flags)
      RakeCompile::Application.app.cc_flags = flags
    end

    def base_cpp_flags(flags)
      RakeCompile::Application.app.base_cpp_flags = flags
    end

    def cpp_flags(flags)
      RakeCompile::Application.app.cpp_flags = flags
    end

    def link_library(library)
      RakeCompile::Application.app.libraries << library
    end

    def pch(name)
      RakeCompile::Application.app.pch = name
    end

    def multifile(*args, &block)
      RakeCompile::MultiFileTask.define_task(*args, &block)
    end

    def static_library(name)
      Target.define_static_library_task(name) do |t|
        yield t
      end

      clear_build_state
    end

    def executable(name)
      Target.define_executable_task(name) do |t|
        yield t
      end

      clear_build_state
    end

    private
    def clear_build_state
      cpp_flags('')
      cc_flags('')
      RakeCompile::Application.app.libraries.clear()
      RakeCompile::Application.app.pch = nil
    end
  end
end

self.extend RakeCompile::DSL
