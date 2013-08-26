FactoryGirl.define do

  factory :response_element, :class => Picasso::SDoc::Definitions::ResponseElement do
    factory :single_response_element do
      name            'user'
      description     'The user attributes'
      required        true
      type            'user'
    end

    factory :list_response_element do
      name            'users'
      description     'The list of users'
      required        true
      elements_type   'user'
    end
  end

end