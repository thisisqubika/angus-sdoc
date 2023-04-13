require 'spec_helper'

require 'spec/json_representations/operations'

module Angus::SDoc::Definitions

  describe Operation do
    include JsonRepresentations::Operations

    describe 'attributes' do
      it { should have_attribute(:name) }
      it { should have_attribute(:code_name) }
      it { should have_attribute(:description) }
      it { should have_attribute(:path) }
      it { should have_attribute(:http_method) }

      it { should have_attribute(:messages) }

      it { should have_attribute(:uri_elements) }
      it { should have_attribute(:request_elements) }
      it { should have_attribute(:response_elements) }
    end

    describe '#message' do
      let(:error_message) {
        message = Message.new
        message.level = Message::ERROR_LEVEL
        message.key = 'testing'
        message
      }

      let(:info_message) {
        message = Message.new
        message.level = Message::INFO_LEVEL
        message.key = 'testing'
        message
      }

      it 'should return nil if messages array is nil' do
        subject.messages = nil

        subject.message('testing', Message::INFO_LEVEL).should be_nil
      end

      # TODO Should this raise an exception instead of returning nil
      it 'should return nil if message level is not allowed' do
        subject.messages = [error_message, info_message]

        subject.message('testing', 'strange-level').should be_nil
      end

      it 'should return nil if message level is nil' do
        subject.messages = [error_message, info_message]

        subject.message('testing', nil).should be_nil
      end

      it 'should return nil if message key is nil' do
        subject.messages = [error_message, info_message]

        subject.message(nil, Message::INFO_LEVEL).should be_nil
      end

      it 'should return the message if the key and level matches' do
        subject.messages = [error_message, info_message]

        subject.message(error_message.key, error_message.level).should eq(error_message)
      end

    end

  end
end
