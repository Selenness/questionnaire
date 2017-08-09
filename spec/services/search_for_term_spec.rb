require 'rails_helper'

describe SearchForTerm, type: :class do
  let(:term) { 'test' }

  describe '#call' do
    it 'calls search' do
      search = described_class.new(term)
      expect(ThinkingSphinx).to receive(:search)
      search.call
    end
  end
end