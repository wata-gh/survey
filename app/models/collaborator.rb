class Collaborator < ActiveRecord::Base
  belongs_to :surveys
  has_many :answers

end
