require 'spec_helper'

require 'spec/json_representations/messages'

describe Angus::SDoc::Definitions::Message do
  include JsonRepresentations::Messages

  describe 'constants' do
    context 'ERROR_LEVEL' do
      subject { Angus::SDoc::Definitions::Message::ERROR_LEVEL }

      it { should == 'error' }
    end

    context 'INFO_LEVEL' do
      subject { Angus::SDoc::Definitions::Message::INFO_LEVEL }

      it { should == 'info' }
    end

    context 'WARNING_LEVEL' do
      subject { Angus::SDoc::Definitions::Message::WARNING_LEVEL }

      it { should == 'warning' }
    end
  end

  describe 'attributes' do

    it { should have_attribute(:level) }
    it { should have_attribute(:key) }
    it { should have_attribute(:description) }
    it { should have_attribute(:status_code) }
    it { should have_attribute(:text) }

  end

end