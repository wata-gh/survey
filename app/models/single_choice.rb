class SingleChoice < Question
  def sel_sum i
    s = self.answers(i).group(:text).count(:text)
    self.choices.inject([]) do |r, c|
      r << {
        name: c[:text],
        y:    (s[c[:value].to_s].present? ? s[c[:value]] : 0),
      }
      r
    end
  end

  def value_data
    JSON.parse self.value
  end

end
