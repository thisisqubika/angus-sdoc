require 'spec_helper'

require 'spec/json_representations/operations'

module Angus::SDoc::Definitions

  describe Operation do
    include JsonRepresentations::Operations

    describe 'attributes' do
      it { is_expected.to have_attribute(:name) }
      it { is_expected.to have_attribute(:code_name) }
      it { is_expected.to have_attribute(:description) }
      it { is_expected.to have_attribute(:path) }
      it { is_expected.to have_attribute(:http_method) }

      it { is_expected.to have_attribute(:messages) }

      it { is_expected.to have_attribute(:uri_elements) }
      it { is_expected.to have_attribute(:request_elements) }
      it { is_expected.to have_attribute(:response_elements) }
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

        expect(subject.message('testing', Message::INFO_LEVEL)).to be_nil
      end

      # TODO Should this raise an exception instead of returning nil
      it 'should return nil if message level is not allowed' do
        subject.messages = [error_message, info_message]

        expect(subject.message('testing', 'strange-level')).to be_nil
      end

      it 'should return nil if message level is nil' do
        subject.messages = [error_message, info_message]

        expect(subject.message('testing', nil)).to be_nil
      end

      it 'should return nil if message key is nil' do
        subject.messages = [error_message, info_message]

        expect(subject.message(nil, Message::INFO_LEVEL)).to be_nil
      end

      it 'should return the message if the key and level matches' do
        subject.messages = [error_message, info_message]

        expect(subject.message(error_message.key, error_message.level)).to eq(error_message)
      end

    end

  end
end
