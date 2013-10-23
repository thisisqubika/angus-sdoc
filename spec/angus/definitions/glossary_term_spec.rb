require 'spec_helper'

require 'spec/json_representations/glossary_terms'

describe Angus::SDoc::Definitions::GlossaryTerm do
  include JsonRepresentations::GlossaryTerms

  describe 'attributes' do
    it { should have_attribute(:short_name) }
    it { should have_attribute(:long_name) }
    it { should have_attribute(:description) }
  end

  subject(:glossary_term) { FactoryGirl.build(:glossary_term) }

  describe '#==' do
    let(:other) { subject.dup }

    it { should_not eq(Object.new)}

    it { should eq(other)}

    it 'returns false if have different short names' do
      other.short_name = "#{glossary_term.short_name}--"

      subject.should_not eq(other)
    end

    it 'returns false if have different long names' do
      other.long_name = "#{glossary_term.long_name}--"

      subject.should_not eq(other)
    end

    it 'returns false if have different descriptions' do
      other.description = "#{glossary_term.description}--"

      subject.should_not eq(other)
    end

    it 'returns true when the have the same attributes' do
      other_object = Angus::SDoc::Definitions::GlossaryTerm.new(glossary_term.short_name,
                                                                  glossary_term.long_name,
                                                                  glossary_term.description)

      subject.should eq(other_object)
    end

  end

end