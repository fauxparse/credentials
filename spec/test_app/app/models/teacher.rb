class Teacher < User
  has_credentials do
    can :teach
    can(:punish, Student) { |teacher, student| teacher == student.house.head }
  end
end
