# -*- coding: utf-8 -*-

module ActionView
  module Helpers
    module FormTagHelper
      alias_method :original_submit_tag, :submit_tag
      def submit_tag(value=nil, options={})
        options[:data] = { disable_with: '送信中...' } unless options[:data]
        original_submit_tag(value, options)
      end
    end
  end
end
