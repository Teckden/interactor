module Interactor
  module PermittedParams
    def self.included(base)
      base.class_eval do
        extend ClassMethods
      end
    end

    module ClassMethods
      def permitted_args_list
        @permitted_args_list ||= []
      end

      def permitted_args(*args)
        @permitted_args_list = args
      end
    end

    module InstanceMethods
      def initialize(context = {})
        context.is_a?(Hash) ? super(filter_permitted_params(context)) : super
      end

      private

      def filter_permitted_params(context)
        permitted_context = context

        if self.class.permitted_args_list.any?
          permitted_context = context.select { |key| self.class.permitted_args_list.include?(key) }
        end

        permitted_context
      end
    end
  end
end
