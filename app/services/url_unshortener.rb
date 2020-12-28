class UrlUnshortener
  ALPHABET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".split(//)

  def self.call(short_url)
    new(short_url).call
  end

  def initialize(short_url)
    @short_url = short_url
  end

  def call
    # based on base2dec() in Tcl translation 
    # at http://rosettacode.org/wiki/Non-decimal_radices/Convert#Ruby
    i = 0
    base = ALPHABET.length
    @short_url.each_char { |c| i = i * base + ALPHABET.index(c) }
    i
  end
end