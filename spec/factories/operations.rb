FactoryBot.define do

  factory :operation, :class => Angus::SDoc::Definitions::Operation do
    code_name     { 'get_users' }
    name          { 'Get users' }
    description   { 'Returns the users list' }
    path          { '/users' }
    http_method   { 'get' }

    factory :full_operation do
      messages            { [FactoryBot.build(:message)] }
      uri_elements        { [FactoryBot.build(:uri_element)] }
      request_elements    { [FactoryBot.build(:list_request_element)] }
      response_elements   { [FactoryBot.build(:list_response_element)] }
    end
  end

end
