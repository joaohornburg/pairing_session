class UrlShortener
  ALPHABET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".split(//)

  def self.call(id)
    new(id).call
  end

  def initialize(id)
    @id = id
  end

  def call
    # from http://refactormycode.com/codes/125-base-62-encoding
    # with only minor modification
    return ALPHABET[0] if @id == 0
    s = ''
    base = ALPHABET.length
    while @id > 0
      s << ALPHABET[@id.modulo(base)]
      @id /= base
    end
    s.reverse
  end
end