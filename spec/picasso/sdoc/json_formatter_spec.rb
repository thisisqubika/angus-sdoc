require 'spec_helper'

require 'spec/json_representations/glossaries'
require 'spec/json_representations/glossary_terms'
require 'spec/json_representations/messages'
require 'spec/json_representations/operations'
require 'spec/json_representations/proxy_operations'
require 'spec/json_representations/representations'
require 'spec/json_representations/representation_fields'
require 'spec/json_representations/response_elements'
require 'spec/json_representations/services'
require 'spec/json_representations/uri_elements'

describe Picasso::SDoc::JsonFormatter do

  subject(:formatter) { Picasso::SDoc::JsonFormatter }

  describe '.format_glossary' do
    include JsonRepresentations::Glossaries

    let(:glossary) { FactoryGirl.build(:glossary) }

    subject { formatter.format_glossary(glossary) }

    it { should match_json_expression(glossary_representation(glossary)) }

  end

  describe '.format_glossary_term' do
    include JsonRepresentations::GlossaryTerms

    let(:glossary_term) { FactoryGirl.build(:glossary_term) }

    subject { formatter.format_glossary_term(glossary_term) }

    it { should match_json_expression(glossary_term_representation(glossary_term)) }

  end

  describe '.format_message' do
    include JsonRepresentations::Messages

    let(:message) { FactoryGirl.build(:message) }

    subject { formatter.format_message(message) }

    it { should match_json_expression(message_representation(message)) }

  end

  describe '.format_operation' do
    include JsonRepresentations::Operations

    let(:operation) { FactoryGirl.build(:full_operation) }

    subject { formatter.format_operation(operation) }

    it { should match_json_expression(operation_representation(operation)) }

  end

  describe '.format_proxy_operation' do
    include JsonRepresentations::ProxyOperations

    let(:proxy_operation) { FactoryGirl.build(:proxy_operation) }

    subject { formatter.format_proxy_operation(proxy_operation) }

    it { should match_json_expression(proxy_operation_representation(proxy_operation)) }

  end

  describe '.format_representation' do
    include JsonRepresentations::Representations

    let(:representation) { FactoryGirl.build(:full_representation) }

    subject { formatter.format_representation(representation) }

    it { should match_json_expression(representation_representation(representation)) }

  end

  describe '.format_representation_field' do
    include JsonRepresentations::RepresentationFields

    subject { formatter.format_representation_field(representation_field) }

    context 'when a single element representation' do
      let(:representation_field) { FactoryGirl.build(:single_representation_field) }

      it { should match_json_expression(representation_field_representation(representation_field)) }
    end

    context 'when a list element representation' do
      let(:representation_field) { FactoryGirl.build(:list_representation_field) }

      it { should match_json_expression(representation_field_representation(representation_field)) }
    end

  end

  describe '.format_request_element' do
    include JsonRepresentations::RequestElements

    subject { formatter.format_request_element(request_element) }

    context 'when a single request element' do
      let(:request_element) { FactoryGirl.build(:single_request_element) }

      it { should match_json_expression(request_element_representation(request_element)) }
    end

    context 'when a list request element' do
      let(:request_element) { FactoryGirl.build(:list_request_element) }

      it { should match_json_expression(request_element_representation(request_element)) }
    end

  end

  describe '.format_response_element' do
    include JsonRepresentations::ResponseElements

    subject { formatter.format_response_element(response_element) }

    context 'when a single response element' do
      let(:response_element) { FactoryGirl.build(:single_response_element) }

      it { should match_json_expression(response_element_representation(response_element)) }
    end

    context 'when a list response element' do
      let(:response_element) { FactoryGirl.build(:single_response_element) }

      it { should match_json_expression(response_element_representation(response_element)) }
    end

  end

  describe '.format_service' do
    include JsonRepresentations::Services

    let(:service) { FactoryGirl.build(:full_service) }

    subject { formatter.format_service(service) }

    it { should match_json_expression(service_representation(service)) }

  end

  describe '.format_uri_element' do
    include JsonRepresentations::UriElements

    let(:uri_element) { FactoryGirl.build(:uri_element) }

    subject { formatter.format_uri_element(uri_element) }

    it { should match_json_expression(uri_element_representation(uri_element)) }

  end

end