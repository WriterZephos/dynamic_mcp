module DynamicMcp
  module Utilities
    module FileOps
      def self.get_all_files(root, path)
        full_path = File.join(root, path)

        if File.file?(full_path)
          [full_path]
        elsif File.directory?(File.join(root, path))
          Dir.glob(File.join(full_path, '**', '*')).select { |f| File.file?(f) }
        else
          []
        end
      end
    end
  end
end

