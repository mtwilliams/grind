module Tetrahedron
  class MisconfiguredError < Error
    def initialize(setting, reason)
      super("The setting `#{setting}` is misconfigured: #{reason}!")
    end
  end
end
