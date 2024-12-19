require 'spec_helper'

require 'spec/json_representations/glossary_terms'

describe Angus::SDoc::Definitions::GlossaryTerm do
  include JsonRepresentations::GlossaryTerms

  describe 'attributes' do
    it { is_expected.to have_attribute(:short_name) }
    it { is_expected.to have_attribute(:long_name) }
    it { is_expected.to have_attribute(:description) }
  end

  subject(:glossary_term) { FactoryBot.build(:glossary_term) }

  describe '#==' do
    let(:other) { subject.dup }

    it { is_expected.not_to eq(Object.new)}

    it { is_expected.to eq(other)}

    it 'returns false if have different short names' do
      other.short_name = "#{glossary_term.short_name}--"

      is_expected.not_to eq(other)
    end

    it 'returns false if have different long names' do
      other.long_name = "#{glossary_term.long_name}--"

      is_expected.not_to eq(other)
    end

    it 'returns false if have different descriptions' do
      other.description = "#{glossary_term.description}--"

      is_expected.not_to eq(other)
    end

    it 'returns true when the have the same attributes' do
      other_object = Angus::SDoc::Definitions::GlossaryTerm.new(glossary_term.short_name,
                                                                  glossary_term.long_name,
                                                                  glossary_term.description)

      is_expected.to eq(other_object)
    end

  end

end
