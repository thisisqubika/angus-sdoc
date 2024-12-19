FactoryBot.define do

  factory :service, :class => Angus::SDoc::Definitions::Service do
    name        { 'Twotter' }
    code_name   { 'twotter' }
    version     { '0.1' }

    factory :full_service do
      representations     { [FactoryBot.build(:full_representation)] }
      operations          { [['users', [FactoryBot.build(:full_operation)]]] }
      proxy_operations    { [FactoryBot.build(:proxy_operation)] }
      glossary            { FactoryBot.build(:glossary) }

      after(:build) do |service|
        message = FactoryBot.build(:message)

        service.messages = { message.key => message}
      end
    end
  end

end
