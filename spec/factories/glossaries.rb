FactoryGirl.define do

  factory :glossary, :class => Picasso::SDoc::Definitions::Glossary do
    terms             { [FactoryGirl.build(:glossary_term)] }
  end

end