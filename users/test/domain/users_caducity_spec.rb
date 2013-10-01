require 'rspec'

require_relative '../../lib/users_caducity'

describe 'Users Caducity' do
	it 'is empty when created' do
		Users::UsersCaducity.new.empty?.should be_true
	end
	it 'is not empty if caducity is added' do
		usersCaducity = Users::UsersCaducity.new
		usersCaducity.add 'bla', Time.new
		usersCaducity.empty?.should be_false
	end
	it 'includes an email when it was added with caducity' do
		usersCaducity = Users::UsersCaducity.new
		usersCaducity.add 'bla', Time.new
		usersCaducity.include?('bla').should be_true
	end
end