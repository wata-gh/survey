class Group < ActiveRecord::Base
  has_many :surveys, class_name: 'Surveys'
end
