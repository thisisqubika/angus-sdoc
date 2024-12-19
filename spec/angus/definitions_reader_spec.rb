require 'spec_helper'

describe Angus::SDoc::DefinitionsReader do

  describe '.service_definition' do
    let(:fixtures_path) { 'spec/fixtures' }
    let(:base_path)     { "#{fixtures_path}/definitions" }

    subject { Angus::SDoc::DefinitionsReader.service_definition(base_path) }

    context 'service' do
      its(:name)      { is_expected.to eq('My Service') }
      its(:code_name) { is_expected.to eq('service') }
      its(:version)   { is_expected.to eq('1.0') }
    end

    skip 'proxy operations'

    context 'messages' do
      it 'should correctly load messages' do
        expect(subject.messages.keys).to include('InvalidJsonError', 'UnauthorizedOperationError',
                                             'VerificationNotFoundError', 'BlankConfirmPathError')
      end

      it 'correctly loads a particular message (InvalidJsonError)' do
        message = subject.messages['InvalidJsonError']

        expect(message.status_code).to eq(422)
        expect(message.level).to  eq('error')
        expect(message.description).to eq('Invalid json.')
      end

      it 'should correctly load a particular message (RollbackSuccessful)' do
        message = subject.messages['RollbackSuccessful']

        expect(message.status_code).to eq(200)
        expect(message.level).to eq('info')
        expect(message.description).to eq('Rollback Successful.')
      end

      describe 'errors' do
        context 'message without key' do
          let(:base_path)     { "#{fixtures_path}/message_without_key_definitions" }

          it 'should raise InvalidServiceMessage when there is a message without a key' do
            expect {
              subject
            }.to raise_exception(Angus::SDoc::InvalidServiceMessage.new('InvalidJsonError' ,'Can not create message without level.'))
          end
        end

        context 'message without status code' do
          let(:base_path)     { "#{fixtures_path}/message_without_status_code_definitions" }

          it 'should raise InvalidServiceMessage when there is a message without a key' do
            expect {
              subject
            }.to raise_exception(Angus::SDoc::InvalidServiceMessage.new('InvalidJsonError' ,'Can not create message without a status code.'))
          end
        end

      end
    end

    context 'representations' do
      let(:rollback_payment_multi) { subject.representations.find { |rep| rep.name == 'rollback_payment_multi' } }

      it 'correctly loads a particular representation' do
        expect(rollback_payment_multi).not_to be_nil # Should exists this representation
      end

      it 'should correctly load it\'s fields' do
        fields = [
          Angus::SDoc::Definitions::RepresentationField.new('action', 'Confirmation action', true, 'string'),
          Angus::SDoc::Definitions::RepresentationField.new('response', 'Service response', true, 'string'),
          Angus::SDoc::Definitions::RepresentationField.new('response_details', 'Service response details', true, 'string'),
          Angus::SDoc::Definitions::RepresentationField.new('shop_process_id', 'Internal store id', true, 'integer'),
          Angus::SDoc::Definitions::RepresentationField.new('token', 'Authorization token.', true, 'string')
        ]

        expect(rollback_payment_multi.fields).to eq(fields)
      end
    end

    context 'operations' do
      let(:namespace) { 'users' }

      let(:create_multi_buy) { subject.operation_definition(namespace, 'create_multi_buy') }

      it 'correctly loads a particular operation' do
        expect(create_multi_buy).not_to be_nil
      end

      it 'correctly loads it\'s name' do
        expect(create_multi_buy.name).to eq('Create multi-item buy.')
      end

      it 'correctly loads it\'s description' do
        description = 'Begins buy process.'

        expect(create_multi_buy.description).to include(description)
      end

      it 'correctly loads it\'s path' do
        expect(create_multi_buy.path).to eq('/multi_buy')
      end

      it 'correctly loads it\'s method' do
        expect(create_multi_buy.http_method).to eq('post')
      end

      it 'correctly loads it\'s requests' do
        request_elements = [
          Angus::SDoc::Definitions::RequestElement.new('public_key', 'Store Public key', true, 'string'),
          Angus::SDoc::Definitions::RequestElement.new('operation', 'Operation Data', true, 'multi_buy'),
        ]

        expect(create_multi_buy.request_elements).to eq(request_elements)
      end

      skip 'messages'

      skip 'response'
    end

    skip 'glossary'
  end

end
