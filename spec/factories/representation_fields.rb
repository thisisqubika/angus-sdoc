FactoryBot.define do

  factory :representation_field, :class => Angus::SDoc::Definitions::RepresentationField do
    factory :single_representation_field do
      name          { 'user_id' }
      description   { 'The user identifier' }
      required      { true }
      type          { 'integer' }
      optional      { false }
    end

    factory :list_representation_field do
      name            { 'user_ids' }
      description     { 'The users identifiers' }
      required        { true }
      elements_type   { 'integer' }
    end
  end

end
