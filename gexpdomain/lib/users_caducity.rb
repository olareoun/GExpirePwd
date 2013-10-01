module Users
	class UsersCaducity

		def initialize
			@caducities = []
		end

		def empty?
			@caducities.empty?
		end

		def add(user, caducity)
			@caducities << UserCaducity.new(user, caducity)
		end

		def include?(user)
			@caducities.map(&:user).include? user
		end

		def caducatesOn(date)
			@caducities.select{|userCaducity| userCaducity.caducity == date}.map(&:user)
		end

		def setNewCaducity(users, days)
			usersCaducityToReset = @caducities.select{|userCaducity| users.include? userCaducity.user}
			usersCaducityToReset.each do |userCaducity|
				userCaducity.caducity = userCaducity.caducity + days
			end
		end

	end

	class UserCaducity

		attr_accessor :user, :caducity

		def initialize(user, caducity)
			@user = user
			@caducity = caducity
		end

	end
end