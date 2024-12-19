FactoryBot.define do

  factory :representation, :class => Angus::SDoc::Definitions::Representation do
    name { 'user' }

    factory :full_representation do
      fields { [FactoryBot.build(:single_representation_field)] }
    end
  end

end
