require 'test_helper'
require 'rake'

class DSLTest < Minitest::Test
  include Rake::DSL
  include RakeCompile::DSL

  def test_build_directory_task
    build_directory 'foo'

    task = Rake::Task['foo']
    assert !task.nil?
    assert_equal 'foo', task.name
  end

end
