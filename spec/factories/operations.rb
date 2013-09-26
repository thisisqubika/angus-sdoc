FactoryGirl.define do

  factory :operation, :class => Picasso::SDoc::Definitions::Operation do
    code_name             'get_users'
    name                  'Get users'
    description           'Returns the users list'
    path                  '/users'
    method                'get'

    factory :full_operation do
      messages            { [FactoryGirl.build(:message)] }
      uri_elements        { [FactoryGirl.build(:uri_element)] }
      request_elements    { [FactoryGirl.build(:list_request_element)] }
      response_elements   { [FactoryGirl.build(:list_response_element)] }
    end
  end

end