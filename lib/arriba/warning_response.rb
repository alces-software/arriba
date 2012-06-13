module Arriba
  class WarningResponse
    attr_accessor :warnings, :data
    def initialize(warnings, data)
      self.warnings = warnings
      self.data = data
    end
  end
end
