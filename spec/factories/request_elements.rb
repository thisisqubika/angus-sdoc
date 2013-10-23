FactoryGirl.define do

  factory :request_element, :class => Angus::SDoc::Definitions::RequestElement do
    factory :single_request_element do
      name            'user'
      description     'The user attributes'
      required        true
      type            'user'
    end

    factory :list_request_element do
      name            'user_ids'
      description     'The list users ids'
      required        true
      elements_type   'integer'
    end
  end

end