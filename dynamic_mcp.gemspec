require_relative "lib/dynamic_mcp/version"

Gem::Specification.new do |s|
  s.name        = "dynamic_mcp"
  s.version     = ::DynamicMcp::VERSION
  s.summary     = "A dynamic and flexible Ruby MCP server"
  s.description = "DynamicMcp lets you get an MCP server up an running in seconds " \
                  "and automatically exposes tools, resources, and prompts as you " \
                  "drop them into their designated directories."
  s.authors     = ["Bryant Morrill"]
  s.email       = "bryantreadmorrill@gmail.com"

  s.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{bin,lib,mcp}/**/*", "LICENSE", "Rakefile", "README.md"]
  end

  s.homepage    = "https://rubygems.org/gems/dynamic_mcp"
  s.license     = "MIT"

  s.metadata["homepage_uri"] = s.homepage
  s.metadata["source_code_uri"] = "https://github.com/WriterZephos/dynamic_mcp"
  s.metadata["changelog_uri"] = "https://github.com/WriterZephos/dynamic_mcp"

  s.executables << "deploy_dynamic_mcp"

  s.add_dependency "fast-mcp"
  s.add_dependency "fileutils"
  s.add_dependency "front_matter_parser"
end
