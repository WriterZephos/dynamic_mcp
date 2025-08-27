module DynamicMcp
  module Utilities
    module FileOps
      def self.get_all_files(path)
        if File.file?(path)
          [path]
        elsif File.directory?(path)
          Dir.glob(File.join(path, '**', '*')).select { |f| File.file?(f) }
        else
          []
        end
      end
    end
  end
end

