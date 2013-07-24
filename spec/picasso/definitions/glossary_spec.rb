require 'spec_helper'

describe Picasso::SDoc::Definitions::Glossary do

  let(:terms_hash_attribute) { {} }
  let(:glossary) { Picasso::SDoc::Definitions::Glossary.new(terms_hash_attribute) }
  subject { glossary }

  describe 'attributes' do
    it { should have_attribute(:terms) }
  end

  describe '#terms_hash' do

    let(:terms_hash_attribute) {
      {
        'fic' => {'long_name' => 'financial_institution_code', 'description' => 'Financial Institution'},
        'doc_type' => {'long_name' => 'document_type', 'description' => 'Document Type'}
      }
    }

    subject { glossary.terms_hash }

    its(:keys) { should eq(['fic', 'doc_type']) }
    its(:values) { should eq([
      Picasso::SDoc::Definitions::GlossaryTerm.new('fic', 'financial_institution_code', 'Financial Institution'),
      Picasso::SDoc::Definitions::GlossaryTerm.new('doc_type', 'document_type', 'Document Type')
    ])}
  end

  describe '#terms_hash_with_long_names' do

    let(:terms_hash_attribute) {
      {
        'fic' => {'long_name' => 'financial_institution_code', 'description' => 'Financial Institution'},
        'doc_type' => {'long_name' => 'document_type', 'description' => 'Document Type'}
      }
    }

    subject { glossary.terms_hash_with_long_names }

    its(:keys) { should eq(['financial_institution_code', 'document_type']) }
    its(:values) { should eq([
      Picasso::SDoc::Definitions::GlossaryTerm.new('fic', 'financial_institution_code', 'Financial Institution'),
      Picasso::SDoc::Definitions::GlossaryTerm.new('doc_type', 'document_type', 'Document Type')
    ])}
  end

end