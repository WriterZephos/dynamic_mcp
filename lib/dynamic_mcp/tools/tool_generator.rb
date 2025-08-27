require_relative "../utilities/file_ops"

module DynamicMcp
  module Tools
    module ToolGenerator
      def self.generate(config)
        tool_paths = config["dynamic_mcp"]["source_data"]["tools"]
        tool_files = tool_paths.flat_map { |path| ::DynamicMcp::Utilities::FileOps.get_all_files(config["server_root"], path) }
        
        tool_files.map do |file|
          require file
          class_name = File.basename(file, ".rb").split('_').map(&:capitalize).join
          klass = Object.const_get(class_name)
          klass.ancestors.include?(FastMcp::Tool) ? klass : nil
        end.compact
      end
    end
  end
end