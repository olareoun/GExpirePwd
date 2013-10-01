require 'google/api_client'

require_relative 'service_account'
require_relative 'not_admin_exception'

module Users
	class UsersDomain
		def initialize(admin)
			@admin = admin
			@serviceAccount = ServiceAccount.new
			@client = Google::APIClient.new
			@api = @client.discovered_api('admin', 'directory_v1')
			@client.authorization = @serviceAccount.authorize(admin)
			raise NotAdminException if !isAdmin
			@adminId = getCustomerId admin
		end

		def getUsers
			result = @client.execute(
				:api_method => @api.users.list, 
				:parameters => {
					'customer' => @adminId
				})
			result.data.users.map{|user| user['primaryEmail']}
		end

		def getUsersWithoutCaducity(usersCaducity = nil)
			emails = getUsers
			return emails if usersCaducity.nil?
			extractUsersWithoutCaducity emails, usersCaducity
		end

		def extractUsersWithoutCaducity(emails, usersCaducity)
			emails.reject{|email| usersCaducity.include? email}
		end

		def changePasswordNextTime(email)
			body_object = @api.users.patch.request_schema.new({
					'changePasswordAtNextLogin' => true
				})
			user = @client.execute(
				:api_method => @api.users.patch, 
				:body_object => body_object,
				:parameters => {
					'userKey' => email
				})
			puts user.status
		end

		def isAdmin
			user = @client.execute(
				:api_method => @api.users.get, 
				:parameters => {
					'userKey' => @admin
				})
			!user.data['isAdmin'].nil? && user.data['isAdmin']
		end

		private 

		def getCustomerId(email)
			user = @client.execute(
				:api_method => @api.users.get, 
				:parameters => {
					'userKey' => email
				})
			customerId = user.data['customerId']
		end

		def extractDomain(email)
			email.scan(/(.+)@(.+)/)[0][1]
		end

	end
end