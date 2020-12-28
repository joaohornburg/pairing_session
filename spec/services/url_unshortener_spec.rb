require 'rails_helper'

RSpec.describe UrlUnshortener do
  describe '#call' do
    it 'returns the correct ID' do
      expect(described_class.call('a')).to eq 0
      expect(described_class.call('b')).to eq 1
      expect(described_class.call('bb')).to eq 63
    end
  end
end