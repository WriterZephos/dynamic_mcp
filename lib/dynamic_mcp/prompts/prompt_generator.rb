require "front_matter_parser"
require_relative "../utilities/file_ops"

module DynamicMcp
  module Prompts
    module PromptGenerator
      def self.generate(config)
        prompt_paths = config["dynamic_mcp"]["source_data"]["prompts"]
        prompt_files = prompt_paths.flat_map { |path| ::DynamicMcp::Utilities::FileOps.get_all_files(config["server_root"], path) }

        prompt_files.map do |file|
          ext = File.extname(file)
          
          if ext == ".md" || ext == ".markdown"
            define_prompt(file)
          end
        end
      end

      def self.define_prompt(file)
        parsed = FrontMatterParser::Parser.parse_file(file)

        klass = Class.new(FastMcp::Tool) do
          description "This tool outputs a prompt. #{parsed.front_matter["description"]}"
          @name = parsed.front_matter["name"]
          @content = parsed.content

          def self.content
            @content
          end

          def call
            self.class.content
          end

          def self.name
            @name
          end
        end

        klass
      end
    end
  end
end