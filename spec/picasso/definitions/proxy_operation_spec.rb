require 'spec_helper'

describe Picasso::SDoc::Definitions::Representation do

  describe 'attributes' do
    it { should have_attribute(:name) }
    it { should have_attribute(:fields) }
  end

end