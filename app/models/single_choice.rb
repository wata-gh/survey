class SingleChoice < Question
  def sel_sum
    s = self.answers.group(:text).count(:text)
    self.choices.inject [] do |r, c|
      r << {
        name: c[:text],
        y:    (s[c[:value].to_s].present? ? s[c[:value]] : 0),
      }
    end
  end
end
