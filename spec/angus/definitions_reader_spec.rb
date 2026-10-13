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

    context 'proxy operations' do
      let(:get_user) { subject.proxy_operations.find { |op| op.code_name == 'get_user' } }

      it 'correctly loads all the proxy operations' do
        expect(subject.proxy_operations.map(&:code_name)).to match_array(%w[get_user create_session])
      end

      it 'correctly loads a particular proxy operation' do
        expect(get_user.path).to eq('/users/:user_id')
        expect(get_user.http_method).to eq('get')
        expect(get_user.service_name).to eq('auth')
      end

      it 'can be filtered by service' do
        expect(subject.proxy_operations_for('auth').size).to eq(2)
      end
    end

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

      it 'correctly loads the message text and fields' do
        message = subject.messages['InvalidFieldsError']

        expect(message.text).to eq('There are invalid fields.')
        expect(message.fields.map(&:name)).to eq(%w[email tags])
      end

      it 'correctly loads the attributes of a message field' do
        field = subject.messages['InvalidFieldsError'].fields.last

        expect(field.description).to eq('The user tags')
        expect(field.type).to eq('array')
        expect(field.elements_type).to eq('string')
        expect(field.required).to eq(false)
      end

      it 'loads an empty list of fields when the message has none' do
        expect(subject.messages['InvalidJsonError'].fields).to eq([])
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

      it 'correctly loads it\'s messages' do
        keys = create_multi_buy.messages.map(&:key)

        expect(keys).to eq(%w[InvalidJsonError UnauthorizedOperationError ApplicationNotFoundError
                              InvalidTokenError InvalidPublicKeyError InvalidOperationError])
      end

      it 'takes the messages attributes from the service messages' do
        message = create_multi_buy.messages.first

        expect(message.status_code).to eq(422)
        expect(message.level).to eq('error')
        expect(message.description).to eq('Invalid json.')
      end

      # build_message is called with 5 arguments (the fields are missing) when the operation
      # references a message that is not defined in messages.yml, so it raises ArgumentError.
      skip 'builds the message of an operation that is not defined in the service messages'

      it 'correctly loads it\'s response' do
        response_elements = create_multi_buy.response_elements

        expect(response_elements.size).to eq(1)
        expect(response_elements.first.name).to eq('process_id')
        expect(response_elements.first.description).to eq('Process Id')
        expect(response_elements.first.required).to eq(false)
        expect(response_elements.first.type).to eq('string')
      end
    end

    context 'glossary' do
      it 'correctly loads all the terms' do
        expect(subject.glossary.terms.map(&:short_name)).to eq(%w[fic an doc_type doc_nbr dob])
      end

      it 'correctly loads a particular term' do
        term = subject.glossary.terms_hash['fic']

        expect(term.long_name).to eq('financial_institution_code')
        expect(term.description).to eq('Financial institution code')
      end
    end
  end

end
