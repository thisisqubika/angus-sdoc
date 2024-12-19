require 'spec_helper'

describe Angus::SDoc::HtmlFormatter do

  subject(:formatter) { Angus::SDoc::HtmlFormatter }

  describe '.format_service' do

    let(:service) { FactoryBot.build(:full_service) }

    context 'when "en" language' do
      subject { formatter.format_service(service, 'en') }

      it { should be_kind_of(String) }
      it { should_not be_empty }
    end

    context 'when "es" language' do
      subject { formatter.format_service(service, 'es') }

      it { should be_kind_of(String) }
      it { should_not be_empty }
    end

  end

end
