class DateChoice < Question
  def sel_sum
    r = [
      {:name => '△', :data => [0] * choices.size},
      {:name => '○', :data => [0] * choices.size},
    ]
    self.answers.pluck(:text).inject r do |r, t|
      increment r, JSON.parse(t)
    end
  end

  def value_data
    {dates: self.value.split("\n").map(&:chomp)}
  end

  private
  def increment r, j
    j['date'].each do |k, v|
      next unless i = choices.index(k)
      next unless k = v == '2' ? 1 : v == '1' ? 0 : nil
      r[k][:data][i] += 1
    end
    r
  end
end
