module RakeCompile
  class Application
    attr_accessor :build_directory
    attr_accessor :base_cpp_flags
    attr_accessor :cpp_flags
    attr_accessor :base_cc_flags
    attr_accessor :cc_flags
    attr_reader :libraries
    attr_accessor :pch

    def self.app
      @app ||= RakeCompile::Application.new
    end

    def initialize()
      @libraries = []
    end

    def full_cpp_flags
      "#{self.base_cpp_flags} #{self.cpp_flags}"
    end

    def full_cc_flags
      "#{self.base_cc_flags} #{self.cc_flags}"
    end

    def flags
      {:cc_flags => self.full_cc_flags, :cpp_flags => self.full_cpp_flags}
    end
  end
end
