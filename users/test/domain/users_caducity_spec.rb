require 'rspec'

require_relative '../../lib/users_caducity'

describe 'Users Caducity' do

	before :each do
		@usersCaducity = Users::UsersCaducity.new
	end

	it 'is empty when created' do
		@usersCaducity.empty?.should be_true
	end
	it 'is not empty if caducity is added' do
		usersCaducity = @usersCaducity
		usersCaducity.add 'bla', Time.new
		usersCaducity.empty?.should be_false
	end
	it 'includes an email when it was added with caducity' do
		usersCaducity = @usersCaducity
		usersCaducity.add 'bla', Time.new
		usersCaducity.include?('bla').should be_true
	end

	describe 'caducity on dates' do
		it 'retrieves the users that have caducity on a date' do
			@usersCaducity.add 'bla', Date.new(2013, 12, 22)
			@usersCaducity.add 'ble', Date.new(2013, 12, 22)
			@usersCaducity.add 'bli', Date.new(2013, 12, 23)
			@usersCaducity.add 'blo', Date.new(2013, 12, 24)

			caducated = @usersCaducity.caducatesOn(Date.new(2013, 12, 22))
			caducated.should include('bla', 'ble')
			caducated.should_not include('bli', 'blo')
		end
	end

	describe 'new caducities' do
		it 'set new caducity date' do
			usersCaducity = Users::UsersCaducity.new
			usersCaducity.add 'bla', Date.new(2013, 12, 22)
			usersCaducity.add 'ble', Date.new(2013, 12, 22)

			usersCaducity.setNewCaducity(['bla', 'ble'], 30)

			usersCaducity.caducatesOn(Date.new(2014, 1, 21)).should include('bla', 'ble')
		end
	end

end