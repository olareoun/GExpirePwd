require 'rspec'
require 'google/api_client'
require 'date'

require_relative '../../lib/users_domain'
require_relative '../../lib/not_admin_exception'
require_relative '../../../IntegrationTest/features/support/domain_config'

describe 'Users Domain' do

	let(:usersDomain){Users::UsersDomain.new DomainConfig.admin}

	it 'raises exception if user is not admin' do
		expect{Users::UsersDomain.new DomainConfig.not_admin}.to raise_error(NotAdminException)
	end

	it 'gets the users' do
		users = usersDomain.getUsers
		DomainConfig.users.each do |email|
			users.include?(email).should be_true
		end
	end

end