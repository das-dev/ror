# frozen_string_literal: true

require 'minitest/test_task'
require 'rubocop/rake_task'
require 'rake/testtask'

# Настройки для запуска мини-тестов
Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/test_*.rb']
  t.verbose = true
end

# Задача для запуска RuboCop
task :rubocop do
  sh 'rubocop'
end

# Дефолтная задача
task default: %w[test rubocop]
