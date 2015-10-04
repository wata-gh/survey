class Surveys < ActiveRecord::Base
  belongs_to :group
  has_many :questions, -> { order(:no) }, :dependent => :destroy, :autosave => true
  has_many :collaborators, :dependent => :destroy
  scope :my_collab, ->(uuid) { where(collaborators: {uuid: uuid}) }
  scope :current_group, ->(subdomain) { joins(:group).where(groups: {name: subdomain}) }
  scope :my_answer, ->(params, uuid) {
    eager_load(:questions, :collaborators).find_by({
      id: params[:survey_id],
      questions:     {id:   params[:question_id]},
      collaborators: {uuid: uuid},
    })
  }
  validates_presence_of :name
  validates_presence_of :questions, :on => :update
  paginates_per 10
  before_save :create_hash_key
  accepts_nested_attributes_for :questions, :allow_destroy => true
  mount_uploader :image, SurveyUploader

  def create_hash_key
    if self.hash_key.blank?
      self.hash_key = Digest::MD5.hexdigest(self.name + Time.now.to_s)
    end
  end
end
