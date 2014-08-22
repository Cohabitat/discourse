role :app,       "cohabitat-discourse-production.srv.svada.net.srv.svada.net:32822", :primary => true 
role :db,        "cohabitat-discourse-production.srv.svada.net.srv.svada.net:32822", :primary => true

set :rails_env, "production"
set(:branch, "master") unless exists?(:branch)

