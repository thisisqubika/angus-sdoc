require 'spec_helper'

describe Picasso::SDoc::DefinitionsReader do

  describe '.service_definition' do
    let(:fixtures_path) { 'spec/fixtures' }
    let(:base_path)     { "#{fixtures_path}/definitions" }

    subject { Picasso::SDoc::DefinitionsReader.service_definition(base_path) }

    context 'service' do
      its(:name)      { should eq('My Service') }
      its(:code_name) { should eq('service') }
      its(:version)   { should eq('1.0') }
    end

    pending 'proxy operations'

    context 'messages' do
      it 'should correctly load messages' do
        subject.messages.keys.should include('InvalidJsonError', 'UnauthorizedOperationError',
                                             'VerificationNotFoundError', 'BlankConfirmPathError')
      end

      it 'correctly loads a particular message (InvalidJsonError)' do
        message = subject.messages['InvalidJsonError']

        message.status_code.should == 422
        message.level.should == 'error'
        message.description.should == 'Invalid json.'
      end

      it 'should correctly load a particular message (RollbackSuccessful)' do
        message = subject.messages['RollbackSuccessful']

        message.status_code.should eq(200)
        message.level.should eq('info')
        message.description.should eq('Rollback Successful.')
      end

      describe 'errors' do
        context 'message without key' do
          let(:base_path)     { "#{fixtures_path}/message_without_key_definitions" }

          it 'should raise InvalidServiceMessage when there is a message without a key' do
            expect {
              subject
            }.to raise_exception(Picasso::SDoc::InvalidServiceMessage.new('InvalidJsonError' ,'Can not create message without level.'))
          end
        end

        context 'message without status code' do
          let(:base_path)     { "#{fixtures_path}/message_without_status_code_definitions" }

          it 'should raise InvalidServiceMessage when there is a message without a key' do
            expect {
              subject
            }.to raise_exception(Picasso::SDoc::InvalidServiceMessage.new('InvalidJsonError' ,'Can not create message without a status code.'))
          end
        end

      end
    end

    context 'representations' do
      let(:rollback_payment_multi) { subject.representations.find { |rep| rep.name == 'rollback_payment_multi' } }

      it 'correctly loads a particular representation' do
        rollback_payment_multi.should_not be_nil # Should exists this representation
      end

      it 'should correctly load it\'s fields' do
        fields = [
          Picasso::SDoc::Definitions::RepresentationField.new('action', 'Confirmation action', true, 'string'),
          Picasso::SDoc::Definitions::RepresentationField.new('response', 'Service response', true, 'string'),
          Picasso::SDoc::Definitions::RepresentationField.new('response_details', 'Service response details', true, 'string'),
          Picasso::SDoc::Definitions::RepresentationField.new('shop_process_id', 'Internal store id', true, 'integer'),
          Picasso::SDoc::Definitions::RepresentationField.new('token', 'Authorization token.', true, 'string')
        ]

        rollback_payment_multi.fields.should == fields
      end
    end

    context 'operations' do
      let(:create_multi_buy) { subject.operations.find { |rep| rep.code_name == 'create_multi_buy' } }

      it 'correctly loads a particular operation' do
        create_multi_buy.should_not be_nil
      end

      it 'correctly loads it\'s name' do
        create_multi_buy.name.should eq('Create multi-item buy.')
      end

      it 'correctly loads it\'s description' do
        description = 'Begins buy process.'

        create_multi_buy.description.should include(description)
      end

      it 'correctly loads it\'s path' do
        create_multi_buy.path.should eq('/multi_buy')
      end

      it 'correctly loads it\'s method' do
        create_multi_buy.method.should eq('post')
      end

      it 'correctly loads it\'s requests' do
        request_elements = [
          Picasso::SDoc::Definitions::RequestElement.new('public_key', 'Store Public key', true, 'string'),
          Picasso::SDoc::Definitions::RequestElement.new('operation', 'Operation Data', true, 'multi_buy'),
        ]

        create_multi_buy.request_elements.should eq(request_elements)
      end

      pending 'messages'

      pending 'response'
    end

    pending 'glossary'

  end

end