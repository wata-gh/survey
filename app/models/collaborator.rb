class Collaborator < ActiveRecord::Base
  belongs_to :surveys
  has_many :answers

  enum status: [:not_yet, :done]
end
