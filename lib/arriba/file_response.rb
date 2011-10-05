module Arriba
  class FileResponse
    attr_accessor :io, :filename, :mimetype, :disposition, :length
    def initialize(io, filename, mimetype, disposition, length)
      self.io = io
      self.filename = filename
      self.length = length
      self.mimetype = mimetype
      self.disposition = disposition
    end
  end
end
