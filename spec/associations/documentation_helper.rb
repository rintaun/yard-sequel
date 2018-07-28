%w[bare_calls].each do |sub_dir|
  Dir.chdir File.join(File.dirname(__FILE__), sub_dir) do
    YARD::CLI::Yardoc.run('-n', '-q', '--plugin sequel')
  end
end
