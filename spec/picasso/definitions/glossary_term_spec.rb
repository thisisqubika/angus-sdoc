require 'spec_helper'

describe Picasso::SDoc::Definitions::GlossaryTerm do

  describe 'attributes' do
    it { should have_attribute(:short_name) }
    it { should have_attribute(:long_name) }
    it { should have_attribute(:description) }
  end

  describe '#==' do
    let(:short_name) { Faker::Name.suffix }
    let(:long_name) { Faker::Name.name }
    let(:description) { Faker::Name.title }

    subject { Picasso::SDoc::Definitions::GlossaryTerm.new(short_name, long_name, description) }

    let(:other) { subject.dup }

    it { should_not eq(Object.new)}

    it 'returns false if have different short names' do
      other.short_name= Faker::Name.prefix

      subject.should_not eq(other)
    end

    it 'returns false if have different long names' do
      other.long_name= Faker::Name.name

      subject.should_not eq(other)
    end

    it 'returns false if have different descriptions' do
      other.description= Faker::Name.title

      subject.should_not eq(other)
    end

    it 'returns true when the have the same attributes' do
      other_object = Picasso::SDoc::Definitions::GlossaryTerm.new(short_name, long_name, description)

      subject.should eq(other_object)
    end

    it { should eq(subject.dup)}
  end

end