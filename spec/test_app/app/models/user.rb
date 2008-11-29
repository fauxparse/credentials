class User < ActiveRecord::Base
  belongs_to :school
  belongs_to :house
  has_and_belongs_to_many :groups
  
  has_credentials do
    can :breathe
    can :apparate, :location, :unless => lambda { |user, location| location.to_s =~ /^Hogwarts/ }
  end
  
  alias_attribute :to_s, :name
end
