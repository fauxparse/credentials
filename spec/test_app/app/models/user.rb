class User < ActiveRecord::Base
  has_and_belongs_to_many :groups
  
  has_credentials do
    can :breathe
    can :apparate, :location, :unless => lambda { |user, location| location == "Hogwarts" }
  end
end
