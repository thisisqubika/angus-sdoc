require 'spec_helper'

require 'spec/json_representations/representations'

describe Angus::SDoc::Definitions::Representation do
  include JsonRepresentations::Representations

  describe 'attributes' do
    it { should have_attribute(:name) }
    it { should have_attribute(:fields) }
  end

end
