require 'spec_helper'

describe Picasso::SDoc::Definitions::Operation do

  describe 'attributes' do
    it { should have_attribute(:name) }
    it { should have_attribute(:code_name) }
    it { should have_attribute(:description) }
    it { should have_attribute(:path) }
    it { should have_attribute(:method) }

    it { should have_attribute(:messages) }

    it { should have_attribute(:uri_elements) }
    it { should have_attribute(:request_elements) }
    it { should have_attribute(:response_elements) }
  end

  # TODO test message array  is nil
  # TODO test key or level nil
  pending '#message'

end