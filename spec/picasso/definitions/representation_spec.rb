require 'spec_helper'

describe Picasso::SDoc::Definitions::ProxyOperation do

  describe 'attributes' do
    it { should have_attribute(:code_name) }
    it { should have_attribute(:path) }
    it { should have_attribute(:method) }

    it { should have_attribute(:service_name) }
  end

end