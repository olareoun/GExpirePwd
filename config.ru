require File.join(File.dirname(__FILE__), 'web/app.rb')
require File.join(File.dirname(__FILE__), 'web/public.rb')

map "/" do
   run Public
end

map "/domain" do
   run Web
end

