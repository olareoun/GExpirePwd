require 'rspec'
require 'google/api_client'
require 'date'

require_relative '../../lib/domain'
require_relative '../../../users/lib/users_domain'
require_relative '../../../IntegrationTest/features/support/domain_config'

describe 'GExpire Domain' do

	let(:gexpDomain){GExpire::Domain.new DomainConfig.admin}
	let(:usersDomain){Users::UsersDomain.new DomainConfig.admin}

	describe 'password caducity' do
		describe 'fetch users from domain that does not have caducity' do
			it 'when no one has caducity retrieves all' do
				usersWithoutCaducity = gexpDomain.getUsersWithoutCaducity
				DomainConfig.users.each do |email|
					usersWithoutCaducity.include?(email).should be_true
				end
			end
			it 'when there are users with caducity retrieves the others' do
				gexpDomain.addCaducity([DomainConfig.admin, DomainConfig.not_admin], Time.new)

				usersWithoutCaducity = gexpDomain.getUsersWithoutCaducity

				DomainConfig.users.reject{|user| [DomainConfig.admin, DomainConfig.not_admin].include? user}.each do |email|
					usersWithoutCaducity.include?(email).should be_true
				end
			end
			it 'when everyone has caducity retrieves an empty list' do
				gexpDomain.addCaducity(DomainConfig.users, Time.new)

				usersWithoutCaducity = gexpDomain.getUsersWithoutCaducity

				usersWithoutCaducity.should be_empty
			end
		end
		it 'expire password for users with caducity on date' do
			gexpDomain.addCaducity([DomainConfig.admin, DomainConfig.not_admin], Date.new(2013, 12, 22))
			gexpDomain.addCaducity(DomainConfig.users.reject{|user| [DomainConfig.admin, DomainConfig.not_admin].include? user}, Date.new(2013, 12, 25))

			expiredEmails = gexpDomain.expirePasswordForDate Date.new(2013, 12, 22)
			
			expiredEmails.each do |email|
				usersDomain.shouldResetPassword?(email).should be_true
			end

		end
		it 'set new caducity date' do
			gexpDomain.addCaducity([DomainConfig.admin, DomainConfig.not_admin], Date.new(2013, 12, 22))

			gexpDomain.setNewCaducity([DomainConfig.admin, DomainConfig.not_admin], 30)

			gexpDomain.caducatesOn(Date.new(2014, 1, 21)).should include(DomainConfig.admin, DomainConfig.not_admin)
		end
	end

end