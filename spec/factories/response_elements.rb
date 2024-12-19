FactoryBot.define do

  factory :response_element, :class => Angus::SDoc::Definitions::ResponseElement do
    factory :single_response_element do
      name          { 'user' }
      description   { 'The user attributes' }
      required      { true }
      type          { 'user' }
      optional      { false }
    end

    factory :list_response_element do
      name            { 'users' }
      description     { 'The list of users' }
      required        { true }
      elements_type   { 'user' }
      optional        { false }
    end
  end

end
