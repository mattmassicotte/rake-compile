module RakeCompile
  def self.compiler_for_source(source, flags=nil)
    cpp_flags = cc_flags = flags

    if flags.is_a? Hash
      cpp_flags = flags[:cpp_flags]
      cc_flags = flags[:cc_flags]
    end

    case File.extname(source)
    when '.cpp', '.cc', '.hpp'
      "c++ #{cpp_flags}"
    when ".c", ".h"
      "cc #{cc_flags}"
    else
      raise("Don't know how to compile #{source}")
    end
  end
end
