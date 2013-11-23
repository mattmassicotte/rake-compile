module RakeCompile
  def self.install(src, dst)
    RakeCompile.log("INSTALL".yellow, dst)
    FileUtils.rm_f(dst)
    FileUtils.cp(src, dst)
  end
  def self.uninstall(path)
    RakeCompile.log("UNINSTALL".yellow, path)
    FileUtils.rm_rf(path)
  end
end
