module FeedbacksHelper

  def can_edit_feedback?
    @controller.send :can_edit_feedback?
  end

  def can_view_feedback?
    @controller.send :can_view_feedback?
  end

  def feedback_question(f, method)
    content_tag(:table, :width => '100%') do
      content_tag(:tr) do
        (1..5).to_a.reverse.collect do |v|
          content_tag(:th, :style => 'text-align: center;') do
            content_tag(:strong, v) + f.radio_button(method, v, :disabled => !can_edit_feedback?)
          end
        end.join("\n")
      end + content_tag(:tr) do
        content_tag(:td, '&nbsp;') +
        content_tag(:td, '&laquo; Better', :style => 'text-align: center;') +
        content_tag(:td, '&nbsp;') +
        content_tag(:td, 'Worse &raquo;', :style => 'text-align: center;') +
        content_tag(:td, '&nbsp;')
      end
    end
  end
end
