require_relative '../../users/lib/users_domain'
require_relative 'users_caducity'

module GExpire
	class Domain

		def initialize(admin)
			@usersDomain = Users::UsersDomain.new admin
			@usersCaducity = Users::UsersCaducity.new
		end

		def addCaducity(emails, caducity)
			emails.each do |email|
				@usersCaducity.add email, caducity
			end
		end

		def setNewCaducity(emails, days)
			@usersCaducity.setNewCaducity(emails, days)
		end

		def getUsersWithoutCaducity(usersCaducity = nil)
			emails = @usersDomain.getUsers
			return emails if @usersCaducity.nil?
			extractUsersWithoutCaducity emails
		end

		def extractUsersWithoutCaducity(emails)
			emails.reject{|email| @usersCaducity.include? email}
		end

		def expirePasswordForDate(date)
			emails = @usersCaducity.caducatesOn(date)
			emails.each do |email|
				@usersDomain.changePasswordNextTime email
			end
			emails
		end

		def caducatesOn(date)
			@usersCaducity.caducatesOn date
		end

	end
end