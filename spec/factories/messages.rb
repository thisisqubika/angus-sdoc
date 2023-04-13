FactoryGirl.define do

  factory :message, :class => Angus::SDoc::Definitions::Message do
    key           'QueryNotAllowedError'
    level         'error'
    status_code   409
    description   'The query operation is not permitted.'
    text          'The query operation is not permitted.'
  end

end
