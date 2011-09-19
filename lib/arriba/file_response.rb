module Arriba
  class FileResponse
    attr_accessor :io, :filename, :mimetype, :disposition
    def initialize(io, filename, mimetype, disposition)
      self.io = io
      self.filename = filename
      self.mimetype = mimetype
      self.disposition = disposition
    end
  end
end
