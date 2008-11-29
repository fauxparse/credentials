class School < ActiveRecord::Base
  has_many :students
  has_many :teachers
  has_many :houses
  
  alias_attribute :to_s, :name
end
