FactoryGirl.define do

  factory :service, :class => Picasso::SDoc::Definitions::Service do
    name        'Twotter'
    code_name   'twotter'
    version     '0.1'

    factory :full_service do
      representations     { [FactoryGirl.build(:full_representation)] }
      operations          { [FactoryGirl.build(:full_operation)] }
      proxy_operations    { [FactoryGirl.build(:proxy_operation)] }
      glossary            { FactoryGirl.build(:glossary) }

      after(:build) do |service|
        message = FactoryGirl.build(:message)

        service.messages = { message.key => message}
      end
    end
  end

end