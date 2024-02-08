# frozen_string_literal: true

require "rake/testtask"
require "rubocop/rake_task"

# Настройки для запуска мини-тестов
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/test_*.rb"]
  t.verbose = true
end

# Задача для запуска RuboCop
RuboCop::RakeTask.new

# Дефолтная задача
task default: %w[test rubocop]
