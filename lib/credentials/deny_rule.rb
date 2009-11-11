module Credentials
  class DenyRule < Rule
    def deny?(*args)
      self.match?(*args)
    end
  end
end