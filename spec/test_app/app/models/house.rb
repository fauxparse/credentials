class House < ActiveRecord::Base
  belongs_to :head, :class_name => "Teacher"
  has_many :students
  belongs_to :school
  
  credentials do |house|
    house.can :go_crying_to, Teacher, :if => lambda { |house, teacher| teacher == house.head }
  end
end
