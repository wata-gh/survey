class Answer < ActiveRecord::Base
  belongs_to :collaborator
  belongs_to :question

end
