class Student < User
  has_credentials do
    can :stay_and_fight, :unless => :new_record?
  end
end
