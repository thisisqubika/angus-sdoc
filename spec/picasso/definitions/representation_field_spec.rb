require 'spec_helper'

require 'spec/json_representations/representation_fields'

describe Picasso::SDoc::Definitions::RepresentationField do
  include JsonRepresentations::RepresentationFields

  describe 'attributes' do
    it { should have_attribute(:name) }
    it { should have_attribute(:description) }
    it { should have_attribute(:required) }
    it { should have_attribute(:type) }
    it { should have_attribute(:elements_type) }
  end

end