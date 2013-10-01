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

	end

	class UserCaducity

		attr_accessor :user

		def initialize(user, caducity)
			@user = user
			@caducity = caducity
		end

	end
end