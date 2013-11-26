require 'spec_helper'

require 'spec/json_representations/proxy_operations'

describe Angus::SDoc::Definitions::ProxyOperation do
  include JsonRepresentations::ProxyOperations

  describe 'attributes' do
    it { should have_attribute(:code_name) }
    it { should have_attribute(:path) }
    it { should have_attribute(:http_method) }

    it { should have_attribute(:service_name) }
  end

end