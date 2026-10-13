require 'spec_helper'

describe Angus::SDoc::Definitions::Service do

  describe 'attributes' do
    it { should have_attribute(:name) }
    it { should have_attribute(:code_name) }
    it { should have_attribute(:version) }
    it { should have_attribute(:messages) }
    it { should have_attribute(:operations) }
    it { should have_attribute(:proxy_operations) }
    it { should have_attribute(:representations) }
    it { should have_attribute(:glossary) }
  end

  let(:error_message) do
    FactoryBot.build(:message, key: 'QueryNotAllowedError', level: 'error')
  end

  let(:info_message) do
    FactoryBot.build(:message, key: 'RollbackSuccessful', level: 'info', status_code: 200)
  end

  describe '#message' do
    subject(:service) { FactoryBot.build(:service) }

    before do
      service.messages = { error_message.key => error_message, info_message.key => info_message }
    end

    it 'returns the message that matches the key' do
      expect(service.message('QueryNotAllowedError')).to eq(error_message)
    end

    it 'returns the message when the level matches' do
      expect(service.message('RollbackSuccessful', 'info')).to eq(info_message)
    end

    it 'ignores the case of the message level' do
      info_message.level = 'INFO'

      expect(service.message('RollbackSuccessful', 'info')).to eq(info_message)
    end

    it 'returns nil when the level does not match' do
      expect(service.message('RollbackSuccessful', 'error')).to be_nil
    end

    it 'returns nil when the key does not exist' do
      expect(service.message('UnknownError')).to be_nil
    end
  end

  describe '#merge' do
    let(:operation)       { FactoryBot.build(:operation, code_name: 'get_users') }
    let(:other_operation) { FactoryBot.build(:operation, code_name: 'get_posts') }

    let(:representation)       { FactoryBot.build(:representation, name: 'user') }
    let(:other_representation) { FactoryBot.build(:representation, name: 'post') }

    let(:service) do
      FactoryBot.build(:service).tap do |service|
        service.operations      = { 'users' => [operation] }
        service.representations = Set.new([representation])
        service.messages        = { error_message.key => error_message }
      end
    end

    let(:other) do
      FactoryBot.build(:service).tap do |service|
        service.operations      = { 'posts' => [other_operation] }
        service.representations = Set.new([other_representation])
        service.messages        = { info_message.key => info_message }
      end
    end

    before { service.merge(other) }

    it 'merges the operations' do
      expect(service.operations.keys).to match_array(%w[users posts])
    end

    it 'merges the representations' do
      expect(service.representations.to_a).to match_array([representation, other_representation])
    end

    it 'merges the messages' do
      expect(service.messages.keys).to match_array(%w[QueryNotAllowedError RollbackSuccessful])
    end

    it 'does not merge the glossary terms' do
      expect(service.glossary.terms).to be_empty
    end
  end

  describe '#operation_definition' do
    subject(:service) { FactoryBot.build(:service) }

    let(:get_users) { FactoryBot.build(:operation, code_name: 'get_users') }
    let(:get_posts) { FactoryBot.build(:operation, code_name: 'get_posts') }

    before { service.operations = { 'users' => [get_users], 'posts' => [get_posts] } }

    it 'returns the operation of the namespace with the given code name' do
      expect(service.operation_definition('users', 'get_users')).to eq(get_users)
    end

    it 'returns nil when the namespace does not have that operation' do
      expect(service.operation_definition('users', 'get_posts')).to be_nil
    end
  end

  describe '#proxy_operations_for' do
    subject(:service) { FactoryBot.build(:service) }

    let(:auth_operation) do
      FactoryBot.build(:proxy_operation, code_name: 'get_users', service_name: 'auth')
    end

    let(:blog_operation) do
      FactoryBot.build(:proxy_operation, code_name: 'get_posts', service_name: 'blog')
    end

    before { service.proxy_operations = [auth_operation, blog_operation] }

    it 'returns only the proxy operations of the given service' do
      expect(service.proxy_operations_for('auth')).to eq([auth_operation])
    end

    it 'returns an empty list when the service has no proxy operations' do
      expect(service.proxy_operations_for('unknown')).to eq([])
    end
  end

  describe '#representations_hash' do
    subject(:service) { FactoryBot.build(:service) }

    let(:user) { FactoryBot.build(:representation, name: 'user') }
    let(:post) { FactoryBot.build(:representation, name: 'post') }

    it 'is empty when the service has no representations' do
      expect(service.representations_hash).to eq({})
    end

    it 'indexes the representations by name' do
      service.representations = Set.new([user, post])

      expect(service.representations_hash).to eq('user' => user, 'post' => post)
    end
  end

end
