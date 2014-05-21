require 'rspec/core/formatters/documentation_formatter'

# Monkey patch the DocumentationFormatter to output the example
# description before it is run. This helps identify tests that hang.
# Usage: rspec -fd
RSpec::Core::Formatters::DocumentationFormatter.class_eval do
  def example_started(example)
    output.puts "#{current_indentation}#{example.description} (RUNNING...)"
  end
end