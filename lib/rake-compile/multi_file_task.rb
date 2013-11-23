module RakeCompile
  class MultiFileTask < Rake::FileTask
    private
    def invoke_prerequisites(task_args, invocation_chain)
      invoke_prerequisites_concurrently(task_args, invocation_chain)
    end
  end
end
