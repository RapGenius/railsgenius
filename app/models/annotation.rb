class Annotation < ActiveRecord::Base
  belongs_to :created_by, class_name: 'User'
  belongs_to :talk

  validates :talk, :created_by, presence: true

  def set_referent(abstract_html = talk.abstract_as_html)
    self.referent = Nokogiri::HTML(talk.abstract_as_html).at("a[data-id=#{id.to_s.inspect}]").try(:inner_text)
  end

  def body
    super.to_s
  end

  def body_as_html
    HTML::Sanitizer.new.sanitize(body).html_safe
  end

  def truncated_body
    b =
      if body.length > 100
        body[0, 100] + '...'
      else
        body
      end

    HTML::FullSanitizer.new.sanitize(b).html_safe
  end
end
