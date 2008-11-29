class House < ActiveRecord::Base
  belongs_to :head, :class_name => "Teacher"
  has_many :students
  belongs_to :school
  
  has_credentials do
    can(:go_crying_to, Teacher) { |house, teacher| teacher == house.head }
  end
end
