require_relative 'application'
require_relative 'dsl_definition'

module RakeCompile
  class Target
    include Rake::DSL

    attr_reader :objects
    attr_reader :name
    attr_accessor :libraries
    attr_accessor :pch

    def self.define_executable_task(name)
      target = Target.new(name)

      yield target

      target.define_task() do |t|
        t.create_executable()
      end
    end

    def self.define_static_library_task(name)
      target = Target.new(name)

      yield target

      target.define_task() do |t|
        t.create_static_library()
      end
    end

    def initialize(a_name)
      @name = a_name
      @objects = []

      self.setup_pch_task()
    end

    def setup_pch_task
      return if RakeCompile::Application.app.pch.nil?

      pch_source = RakeCompile::Application.app.pch
      pch_output = pch_source.ext('.gch')
      pch_output = File.join(RakeCompile::Application.app.build_directory, pch_output)
      self.pch   = File.absolute_path(pch_output)

      define_object_dependencies(pch_source, self.pch)
    end

    def append_pch_to_flags(pch_file, flags)
      flags = flags.dup

      # Remove the extension.  I'm not certain why this is necessary, but clang freaks out if you do not.
      pch_file = pch_file.ext('')
      pch_flag = " -include '#{pch_file}'"
      flags[:cc_flags] += pch_flag
      flags[:cpp_flags] += pch_flag
      flags
    end

    def define_task()
      CLOBBER.include(self.name)

      dir = File.dirname(self.name)
      directory dir

      # Capture libraries, for use in the block below.  We need to dup the array,
      # because the app copy gets mutated, and we don't just want a reference.
      self.libraries = RakeCompile::Application.app.libraries.dup

      prereqs = [dir, self.objects, self.libraries].flatten

      RakeCompile::MultiFileTask.define_task(self.name => prereqs) do
        yield self
      end
    end

    def create_executable()
      FileUtils.rm_f(self.name)

      RakeCompile.log("BIN".light_blue, self.name)
      linker = 'c++ -std=c++11 -stdlib=libc++'

      inputs = self.objects.join("' '")
      libs = self.libraries.join("' '")

      cmd = "#{linker}"
      cmd += " -o '#{self.name}'"
      cmd += " '#{inputs}'"
      cmd += " '#{libs}'" if libs.length > 0

      Rake::sh(cmd)
    end

    def create_static_library()
      FileUtils.rm_f(self.name)

      inputs = self.objects.join("' '")

      RakeCompile.log("LIB".light_blue, self.name)
      Rake::sh("/usr/bin/ar crs '#{self.name}' '#{inputs}'")
    end

    def add_objects_from_sources(filelist, flags=nil)
      filelist.each { |source| self.add_object_from_source(source, flags) }
    end

    def add_object_from_source(source, flags=nil)
      object = File.join(RakeCompile::Application.app.build_directory, source.ext('.o'))

      add_object(source, object, flags)
    end

    def add_object(source, object, flags=nil)
      object = File.absolute_path(object)
      @objects << object

      define_object_dependencies(source, object, flags)
    end

    def define_object_dependencies(source, object, flags=nil)
      flags ||= RakeCompile::Application.app.flags

      source = File.absolute_path(source)
      dependency_file = "#{object}.deps"

      deps = []
      if File.exist?(dependency_file)
        deps = dependencies_from_deps_file(dependency_file)
      end

      dir = File.dirname(dependency_file)
      directory dir

      # define a file task to create the deps file, which
      # depends on the dependencies themselves.  Also
      # depends on the directory that contains it
      if self.pch && (object != self.pch)
        file(dependency_file => self.pch)
        flags = append_pch_to_flags(self.pch, flags)
      end

      file dependency_file => dir
      file dependency_file => deps do
        RakeCompile.log("DEPS".red, object)
        deps = dependencies_for_source(source, flags)

        File.open(dependency_file, "w+") do |file|
          file << deps.join("\n")
          file << "\n"
        end
      end

      # and, now define the actual object file itself
      file object => [dir, dependency_file] do
        s = RakeCompile.compiler_for_source(source, flags)
        s += " -o '#{object}'"
        s += " -c '#{source}'"

        RakeCompile.log("OBJ".yellow, object)
        Rake::sh(s)
      end

      # make sure these are cleaned
      CLEAN.include(dependency_file)
      CLEAN.include(object)
    end

    def dependencies_for_source(source, flags)
      s = RakeCompile::compiler_for_source(source, flags)
      s += " -MM "
      s += "'#{source}'"

      puts s if verbose() != false
      output = `#{s}`.chomp()

      output.gsub!(" \\\n  ", " ")

      dependencies = output.split(" ")
      dependencies.delete_at(0)  # remove the first element, which is the object file itself
      dependencies.reject! { |x| x.empty? } # remove blanks

      dependencies.collect { |x| File.absolute_path(x) }
    end

    def dependencies_from_deps_file(path)
      deps = []
      File.open(path, 'r') do |file|
        deps = file.readlines()
      end

      deps.collect {|x| x.chomp() }
    end
  end
end
