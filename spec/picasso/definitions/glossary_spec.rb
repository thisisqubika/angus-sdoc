require 'spec_helper'

describe Picasso::SDoc::Definitions::Glossary do

  describe 'attributes' do
    it { should have_attribute(:terms) }
  end

  pending '#terms_hash'
  pending '#terms_hash_with_long_names'

end