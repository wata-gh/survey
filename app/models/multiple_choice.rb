class MultipleChoice < Question
  def sel_sum
    s = Hash.new 0
    answers.joins(:collaborator).where(collaborators: {status: 1}).pluck(:text).each do |t|
      JSON.parse(t).each {|v| s[v] += 1}
    end
    choices.inject [] {|r, c| r << s[c[:value]]}
  end
end
