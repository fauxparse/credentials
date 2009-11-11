module Credentials
  class AllowRule < Rule
    def allow?(*args)
      self.match?(*args)
    end
  end
end