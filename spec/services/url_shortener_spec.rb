require 'rails_helper'

RSpec.describe UrlShortener do
  describe '#call' do
    it 'returns the correct encoding' do
      expect(described_class.call(0)).to eq 'a'
      expect(described_class.call(1)).to eq 'b'
      expect(described_class.call(63)).to eq 'bb'
    end
  end
end