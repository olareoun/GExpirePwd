require_relative '../support/spec_helper'

describe "Login via google", :wip do

  it "visit /login asks for the domain name" do
    visit '/login'
    selector('input#openid_identifier').should_not be_nil
  end

  it "goes to google login when domain name submitted" do
    visit '/login'
    fill_in "openid_identifier", :with => "ideasbrillantes.org"
    click_button "submit"
    puts page.html
    selector("#Email").should_not be_nil
    selector("#Passwd").should_not be_nil
  end

end

def selector string
  find :css, string
end