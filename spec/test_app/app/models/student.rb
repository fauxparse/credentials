class Student < User
  credentials :groups => [ :school, :house ] do
    can :stay_and_fight, :unless => :new_record?
    can :go_crying_to, Headmaster
  end
end
