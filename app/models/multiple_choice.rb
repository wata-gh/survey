class MultipleChoice < Question
  def sel_sum
    s = Hash.new 0
    self.answers.joins(:collaborator).where(collaborators: {status: 1}).pluck(:text).each do |t|
      JSON.parse(t).each {|v| s[v] += 1}
    end
    self.choices.inject [] {|r, c| r << s[c[:value]]; r}
  end

  def value_data
    JSON.parse(self.value)
  end

end
