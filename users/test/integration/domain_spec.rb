require 'rspec'
require 'google/api_client'

require_relative '../../lib/users_domain'
require_relative '../../lib/users_caducity'
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

	describe 'password caducity' do
		describe 'fetch users from domain that does not have caducity' do
			it 'when no one has caducity retrieves all' do
				usersWithoutCaducity = usersDomain.getUsersWithoutCaducity
				DomainConfig.users.each do |email|
					usersWithoutCaducity.include?(email).should be_true
				end
			end
			it 'when there are users with caducity retrieves the others' do
				usersCaducity = Users::UsersCaducity.new
				usersCaducity.add DomainConfig.admin, Time.new
				usersCaducity.add DomainConfig.not_admin, Time.new

				usersWithoutCaducity = usersDomain.getUsersWithoutCaducity usersCaducity

				DomainConfig.users.reject{|user| [DomainConfig.admin, DomainConfig.not_admin].include? user}.each do |email|
					usersWithoutCaducity.include?(email).should be_true
				end
			end
			it 'when everyone has caducity retrieves an empty list' do
				usersCaducity = Users::UsersCaducity.new
				DomainConfig.users.each do |email|
					usersCaducity.add email, Time.new
				end

				usersWithoutCaducity = usersDomain.getUsersWithoutCaducity usersCaducity

				usersWithoutCaducity.should be_empty

			end
		end
	end

end