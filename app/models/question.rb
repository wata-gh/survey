class Question < ActiveRecord::Base
  self.inheritance_column = :_type_disabled
  mount_uploader :image, QuestionUploader
  belongs_to :surveys
  has_many :answers
  validates_presence_of :text
  validate :json_format

  enum :type => {
    :single   => 1,
    :multiple => 2,
    :date     => 8,
    :free     => 9,
  }

  TYPE_NAME = {
    'single'   => '1つ選択',
    'multiple' => '複数選択',
    'date'     => '日程調整',
    'free'     => 'フリーフォーマット',
  }

  TYPE_COMMENT = {
    'single'   => '1つ選択してください',
    'multiple' => '複数選択可',
    'date'     => '日程を入力してください',
    'free'     => 'フリーフォーマット',
  }

  def type_name
    TYPE_NAME[self.type]
  end

  def type_comment
    TYPE_COMMENT[self.type]
  end

  def choices
    return self.value.split("\n").map(&:chomp) if self.date?
    JSON.parse(self.value, {:symbolize_names => true})
  end

  def sel_sum i
    r = []
    if self.single?
      s = self.answers(i).group(:text).count(:text)
      self.choices.each do |c|
        r << {
          :name => c[:text],
          :y    => (s[c[:value].to_s].present? ? s[c[:value]] : 0),
        }
      end
    elsif self.multiple?
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
    elsif self.date?
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
    end
    r
  end

  def error_class
    self.errors.present? ? 'error' : ''
  end
  def text_error_class
    self.errors[:text].present? ? 'error' : ''
  end
  def value_error_class
    self.errors[:value].present? ? 'error' : ''
  end
  def value_data
    begin
      JSON.parse(self.value)
    rescue
      if self.date?
        return {
          :dates => self.value.split("\n").map(&:chomp)
        }
      elsif self.free?
        return []
      end
    end
  end

  def each_date
    self.value.split("\n").map(&:chomp)
  end

  def prev
    @prev ||= Question.find_by surveys_id: self.surveys_id, no: self.no - 1
  end

  def next
    @next ||= Question.find_by surveys_id: self.surveys_id, no: self.no + 1
  end

  def resize_image_url
    return '' unless self.image.url
    path = self.image.url.gsub Survey::Application.config.image_asset_host, ''
    File.join Survey::Application.config.image_asset_host, "/resize/w/:dw/h/:dh/", path
  end

  protected

  def json_format
    if self.single? || self.multiple?
      begin
        JSON.parse self.value
      rescue
        errors[:value] << "not in json format"
      end
    end
  end
end
