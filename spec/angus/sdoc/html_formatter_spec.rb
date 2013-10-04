require 'spec_helper'

describe Angus::SDoc::HtmlFormatter do

  subject(:formatter) { Angus::SDoc::HtmlFormatter }

  describe '.format_service' do

    let(:service) { FactoryGirl.build(:full_service) }

    subject { formatter.format_service(service) }

    it { should be_kind_of(String) }
    it { should_not be_empty }

  end

end