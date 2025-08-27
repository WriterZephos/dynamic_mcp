require "fast_mcp"
require "yaml"

if ENV["DYNAMICMCPDEV"] == "true"
  require_relative "../lib/dynamic_mcp"
else
  require "ruby-mcp"
end

config = ::YAML.load_file("#{__dir__}/config.yml")
tools = ::DynamicMcp::Tools::ToolGenerator.generate(config)
resources = ::DynamicMcp::Resources::ResourceGenerator.generate(config)
prompts = ::DynamicMcp::Prompts::PromptGenerator.generate(config)

server = FastMcp::Server.new(
  name: config["dynamic_mcp"]["server_name"],
  version: config["dynamic_mcp"]["version"]
)

tools.each do |tool|
  server.register_tool(tool)
end

resources.each do |resource|
  server.register_resource(resource)
end

# FastMcp does not yet support prompts
# so we are implementing them as tools
# for now.
prompts.each do |prompt|
  server.register_tool(prompt)
end

server.start


