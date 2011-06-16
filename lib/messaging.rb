# Copyright (C) 2008 Avalanche, LLC.

module Messaging
  TYPES = ['done', 'info', 'error', 'warning']
  
  TYPES.each do |type|
    self.class_eval <<EOF
      private

      def html#{type}mark(msg)
        htmlmark(msg, '#{type}')
      end

      def #{type}mark(msg)
        flashmark(msg, '#{type}')
      end

      def html#{type}message(title, body)
        htmlmessage(title, body, '#{type}')
      end

      def #{type}message(title, body)
        flashmessage(title, body, '#{type}')
      end
EOF
  end

  private
    
  def htmlmark(msg, type = 'info')
    if TYPES.include?(type)
      "<p class=\"#{type}mark\">#{msg}</p>"
    end
  end
    
  def flashmark(msg, type = 'info')
    flash[:messages] = [] unless flash[:messages].is_a?(Array)
    if m = htmlmark(msg, type)
      unless flash[:messages].include?(m)
        flash[:messages] << m
      end
    end
  end
    
  def htmlmessage(title, body, type = 'info')
    if TYPES.include?(type)
      "<div class=\"#{type}message\">\n" \
        "  <p>\n" \
        "    <strong>#{title}</strong>\n" \
        "    <p>#{body}</p>\n" \
        "  </p>\n" \
        "</div>"
    end
  end
    
  def flashmessage(title, body, type = 'info')
    flash[:messages] = [] unless flash[:messages].is_a?(Array)
    if m = htmlmessage(title, body, type)
      unless flash[:messages].include?(m)
        flash[:messages] << m
      end
    end
  end

end