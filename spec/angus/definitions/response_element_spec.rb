require 'spec_helper'

describe Angus::SDoc::Definitions::ResponseElement do

  describe 'attributes' do
    it { should have_attribute(:name) }
    it { should have_attribute(:description) }
    it { should have_attribute(:required) }
    it { should have_attribute(:type) }
    it { should have_attribute(:default) }
    it { should have_attribute(:elements_type) }
  end

end