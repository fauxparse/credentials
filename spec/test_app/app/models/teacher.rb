class Teacher < User
  has_credentials do
    can :teach
  end
end
