require 'rbconfig'
require 'rubygems'
require 'rubygems/specification'
require 'fileutils'

ruby = File.join(ENV["ruby"], "bin", RbConfig::CONFIG['ruby_install_name'])
out = ENV["out"]
bin_path = File.join(ENV["out"], "bin")
gem_home = ENV["GEM_HOME"]
gem_path = ENV["GEM_PATH"].split(":")
install_path = Dir.glob("#{gem_home}/gems/*").first
gemspec_path = ARGV[0]

if defined?(Encoding.default_internal)
  Encoding.default_internal = Encoding::UTF_8
  Encoding.default_external = Encoding::UTF_8
end

gemspec_content = File.read(gemspec_path)
spec = nil
if gemspec_content[0..2] == "---" # YAML header
  spec = Gem::Specification.from_yaml(gemspec_content)
else
  spec = Gem::Specification.load(gemspec_path)
end

FileUtils.mkdir_p("#{out}/nix-support")

# write meta-data
meta = "#{out}/nix-support/gem-meta"
FileUtils.mkdir_p(meta)
FileUtils.ln_s(gemspec_path, "#{meta}/spec")
File.open("#{meta}/name", "w") do |f|
  f.write(spec.name)
end
File.open("#{meta}/install-path", "w") do |f|
  f.write(install_path)
end
File.open("#{meta}/require-paths", "w") do |f|
  f.write(spec.require_paths.join(" "))
end
File.open("#{meta}/executables", "w") do |f|
  f.write(spec.executables.join(" "))
end

# add this gem to the GEM_PATH for dependencies
File.open("#{out}/nix-support/setup-hook", "a") do |f|
  f.puts("addToSearchPath GEM_PATH #{gem_home}")
  spec.require_paths.each do |dir|
    f.puts("addToSearchPath RUBYLIB #{install_path}/#{dir}")
  end
end

# create regular rubygems binstubs
FileUtils.mkdir_p(bin_path)
spec.executables.each do |exe|
  File.open("#{bin_path}/#{exe}", "w") do |f|
    f.write(<<-EOF)
#!#{ruby}
#
# This file was generated by Nix.
#
# The application '#{exe}' is installed as part of a gem, and
# this file is here to facilitate running it.
#

Gem.use_paths "#{gem_home}", #{gem_path.to_s}

require 'rubygems'

load Gem.bin_path(#{spec.name.inspect}, #{exe.inspect})
    EOF
  end

  FileUtils.chmod("+x", "#{bin_path}/#{exe}")
end
