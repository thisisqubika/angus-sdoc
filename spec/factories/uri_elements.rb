FactoryGirl.define do

  factory :uri_element, :class => Picasso::SDoc::Definitions::UriElement do
    name          'user_id'
    description   'The user identifier'
  end

end