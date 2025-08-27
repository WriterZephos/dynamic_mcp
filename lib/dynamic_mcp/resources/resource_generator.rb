require "front_matter_parser"
require_relative "../utilities/file_ops"

module DynamicMcp
  module Resources
    module ResourceGenerator
      def self.generate(config)
        resource_paths = config["dynamic_mcp"]["source_data"]["resources"]
        resource_files = resource_paths.flat_map { |path| ::DynamicMcp::Utilities::FileOps.get_all_files(config["server_root"], path) }

        puts resource_files

        resource_files.map do |file|
          ext = File.extname(file)
          
          if ext == ".rb"
            require file
            class_name = File.basename(file, ".rb").split('_').map(&:capitalize).join
            klass = Object.const_get(class_name)
            klass.ancestors.include?(FastMcp::Resource) ? klass : nil
          elsif ext == ".md" || ext == ".markdown"
            define_resource(file)
          end
        end
      end

      def self.define_resource(file)
        parsed = FrontMatterParser::Parser.parse_file(file)

        klass = Class.new(FastMcp::Resource) do
          uri parsed.front_matter["uri"]
          resource_name parsed.front_matter["resource_name"]
          mime_type parsed.front_matter["mime_type"]
          @content = parsed.content

          def self.content
            @content
          end

          def content
            self.class.content
          end
        end

        klass
      end
    end
  end
end