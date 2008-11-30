class Headmaster < Teacher
  credentials do |headmaster|
    headmaster.can :expel, Student, :if => lambda { |headmaster, student| headmaster.school == student.school }
  end
end
