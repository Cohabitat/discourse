role :app,       "cohabitat-discourse-staging.srv.svada.net:32722", :primary => true 
role :db,        "cohabitat-discourse-staging.srv.svada.net:32722", :primary => true

set :rails_env, "staging"
set(:branch, "master") unless exists?(:branch)

