class Question < ActiveRecord::Base
  include ActiveRecord::Sti::Enum
  mount_uploader :image, QuestionUploader
  belongs_to :surveys
  has_many :answers
  validates_presence_of :text
  validate :json_format

  def prev
    @prev ||= Question.find_by surveys_id: self.surveys_id, no: self.no - 1
  end

  def next
    @next ||= Question.find_by surveys_id: self.surveys_id, no: self.no + 1
  end

  def each_date
    self.value.split("\n").map(&:chomp)
  end

  protected

  def json_format
    if self.single_choice? || self.multiple_choice?
      begin
        JSON.parse self.value
      rescue
        errors[:value] << "not in json format"
      end
    end
  end
end
