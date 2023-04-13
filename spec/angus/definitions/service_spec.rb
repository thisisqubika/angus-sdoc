require 'spec_helper'

describe Angus::SDoc::Definitions::Service do

  describe 'attributes' do
    it { should have_attribute(:name) }
    it { should have_attribute(:code_name) }
    it { should have_attribute(:version) }
    it { should have_attribute(:messages) }
    it { should have_attribute(:operations) }
    it { should have_attribute(:proxy_operations) }
    it { should have_attribute(:representations) }
    it { should have_attribute(:glossary) }
  end

  pending '#message'
  pending '#merge'
  pending '#operation_definition'
  pending '#proxy_operations_for'
  pending '#representations_hash'

end
