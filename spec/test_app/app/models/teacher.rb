class Teacher < User
  credentials do
    can :teach
    can(:punish, Student) { |teacher, student| teacher == student.house.head }
  end
end
