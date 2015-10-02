class DateChoice < Question
  def sel_sum i
    r = [
      {:name => '△', :data => [0] * self.choices.size},
      {:name => '○', :data => [0] * self.choices.size},
    ]
    choices = self.choices
    self.answers(i).each do |a|
      j = JSON.parse a.text
      j['date'].each do |k, v|
        i = choices.index k
        next unless i
        k = v == '2' ? 1 : v == '1' ? 0 : nil
        next unless k
        r[k][:data][i] += 1
      end
    end
    r
  end

  def value_data
    {dates: self.value.split("\n").map(&:chomp)}
  end
end
