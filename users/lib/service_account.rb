require 'google/api_client'

class ServiceAccount
	def initialize
		keyFile = File.read(File.join(File.dirname(__FILE__), 'bb8ba47584f6e6d72fdaee2fbf30e1c3f7c61d4f-privatekey.p12'))
		key = Google::APIClient::PKCS12.load_key(keyFile, 'notasecret')
		@service_account = Google::APIClient::JWTAsserter.new(
		    '445094234984@developer.gserviceaccount.com',
		    ['https://www.googleapis.com/auth/admin.directory.user'],
		    key)
	end

	def authorize(userEmail = nil)
		return @service_account.authorize(userEmail) if !userEmail.nil?
		return @service_account.authorize if userEmail.nil?
	end
end