require 'spec_helper'

describe Picasso::SDoc::Definitions::GlossaryTerm do

  describe 'attributes' do
    it { should have_attribute(:short_name) }
    it { should have_attribute(:long_name) }
    it { should have_attribute(:description) }
  end

end