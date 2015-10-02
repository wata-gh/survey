class MultipleChoice < Question
  def sel_sum i
    r = []
    s = {}
    self.choices.each {|c| s[c[:value].to_s] = 0}
    self.answers.joins(:collaborator).where(collaborators: {status: 1}).each do |a|
      begin
        JSON.parse(a.text).each {|v| s[v] += 1}
      rescue
        if a.text.present?
          s[a.text] = 0 if s[a.text].blank?
          s[a.text] += 1
        end
      end
    end
    self.choices.each do |c|
      r << (s[c[:value].to_s].present? ? s[c[:value]] : 0)
    end
    r
  end

  def value_data
    JSON.parse(self.value)
  end

end
