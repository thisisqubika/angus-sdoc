FactoryBot.define do

  factory :glossary, :class => Angus::SDoc::Definitions::Glossary do
    terms { [FactoryBot.build(:glossary_term)] }
  end

end
