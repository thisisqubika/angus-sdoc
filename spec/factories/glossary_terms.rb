FactoryGirl.define do

  factory :glossary_term, :class => Picasso::SDoc::Definitions::GlossaryTerm do
    short_name    'fic'
    long_name     'financial_institution_code'
    description   'Financial institution code'
  end

end