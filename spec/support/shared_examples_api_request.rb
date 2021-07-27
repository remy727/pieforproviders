# frozen_string_literal: true

require 'rails_helper'

VALID_API_PATH = '/api/v1'

# These are shared examples for typical API calls for a Rails model.
#
# Some examples expect _record_params_ to be defined (e.g. with a let(:record_params) block)
# to be used as parameters that are sent to the server.
# The examples that expect record_params to be defined end with '... with parameters'.
#
# Ex: Assume you are testing the API calls for creating a Business. The
#     record_params are the parameters needed to create a Business.
#
#     let!(:business_params) do
#       {
#         "name": 'Happy Hearts Child Care',
#         "license_type": 'licensed_center',
#         "user_id": user.id
#       }
#     end
#
#     it_behaves_like 'it creates a record', Business do
#       let(:record_params) { business_params }
#     end
#
#     You should define 'user_id' and any other values/variables
#     as needed.
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Examples that test for common error conditions:

# TODO: implement these without rswag dsl
# This example expects the following to be defined with a let(:) block:
#  record_params - parameters to be passed to the server
RSpec.shared_examples 'server error responses for wrong api version with parameters' do |record_name|
  context 'on the wrong api version' do
    include_context 'incorrect api version header'
    context 'when authenticated' do
      include_context 'authenticated user'
      response '500', 'internal server error' do
        let(record_name.to_sym) { { record_name => record_params } }
        run_test!
      end
    end

    context 'when not authenticated' do
      response '500', 'internal server error' do
        let(record_name.to_sym) { { record_name => record_params } }
        run_test!
      end
    end
  end
end

RSpec.shared_examples 'server error responses for wrong api version' do
  context 'on the wrong api version' do
    include_context 'incorrect api version header'
    context 'when authenticated' do
      include_context 'authenticated user'
      response '500', 'internal server error' do
        run_test!
      end
    end

    context 'when not authenticated' do
      response '500', 'internal server error' do
        run_test!
      end
    end
  end
end

# This example expects the following to be defined with a let(:) block:
#  record_params - parameters to be passed to the server
RSpec.shared_examples '401 error if not authenticated with parameters' do |record_name|
  context 'when not authenticated' do
    response '401', 'not authorized' do
      let(record_name.to_sym) { { record_name => record_params } }
      run_test!
    end
  end
end

RSpec.shared_examples '401 error if not authenticated' do
  context 'when not authenticated' do
    response '401', 'not authorized' do
      run_test!
    end
  end
end

# This example expects the following to be defined with a let(:) block:
#  record_params - parameters to be passed to the server
RSpec.shared_examples '404 not found with parameters' do |record_name|
  response '404', "#{record_name} not found" do
    let(:id) { 'invalid' }
    let(record_name.to_sym) { { record_name => record_params } }
    run_test!
  end
end

RSpec.shared_examples '404 not found' do |record_name|
  response '404', "#{record_name} not found" do
    let(:id) { 'invalid' }
    run_test!
  end
end

# ------------------------------------------------------------------------------
