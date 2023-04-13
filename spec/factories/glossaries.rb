FactoryGirl.define do

  factory :glossary, :class => Angus::SDoc::Definitions::Glossary do
    terms             { [FactoryGirl.build(:glossary_term)] }
  end

end
