require 'colorize'

$:.unshift File.dirname(__FILE__)

require File.join('rake-compile', 'logging')
require File.join('rake-compile', 'install')
require File.join('rake-compile', 'compiler')
require File.join('rake-compile', 'multi_file_task')
require File.join('rake-compile', 'dsl_definition')
