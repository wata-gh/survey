module QuestionDecorator

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
    @choices ||= self.date? ? self.value.split("\n").map(&:chomp) : JSON.parse(self.value, {:symbolize_names => true})
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

  def resize_image_url
    return '' unless self.image.url
    path = self.image.url.gsub Survey::Application.config.image_asset_host, ''
    File.join Survey::Application.config.image_asset_host, "/resize/w/:dw/h/:dh/", path
  end
end
