FactoryGirl.define do

  factory :representation, :class => Angus::SDoc::Definitions::Representation do
    name      'user'

    factory :full_representation do
      fields    { [FactoryGirl.build(:single_representation_field)] }
    end
  end

end