FactoryGirl.define do

  factory :proxy_operation, :class => Picasso::SDoc::Definitions::ProxyOperation do
    code_name       'get_users'
    path            'Get user'
    method          'get'
    service_name    'auth'
  end

end