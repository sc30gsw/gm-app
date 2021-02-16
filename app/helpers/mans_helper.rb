module MansHelper
  def render_with_tags(tagbody)
    tagbody.gsub(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/) { |word| link_to word, "/mans/tag/#{word.delete('#')}" }.html_safe
  end
end
