class Teacher < User
  credentials do |teacher|
    teacher.can :teach
    teacher.cannot :expel, Student
    teacher.can :punish, Student, :if => lambda { |teacher, student| teacher == student.house.head }
  end
end
