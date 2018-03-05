require 'oj'

module Rubyhome
  module HTTP
    module ObjectSerializer
      def initialize(resource)
        if resource.respond_to?(:each) && !resource.respond_to?(:each_pair)
          @resources = resource
        else
          @resource = resource
        end
      end

      def root
        nil
      end

      def serializable_hash
        serializable_hash = if @resource
          record_hash(resource)
        elsif @resources
          @resources.map do |resource|
            record_hash(resource)
          end
        end

        if root
          {root => serializable_hash}
        else
          serializable_hash
        end
      end

      def serialized_json
        Oj.dump(serializable_hash)
      end
    end
  end
end
