class Student < User
  credentials :groups => [ :school, :house ] do |student|
    student.can :stay_and_fight, :unless => :new_record?
    student.can :go_crying_to, Teacher, :if => lambda { |student, teacher| teacher.is_a? Headmaster }
  end
end
