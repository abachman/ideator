Prerequisites
-------------

 * Git client
 * Heroku gem: sudo gem install heroku

Usage
-----


    git clone git@github.com:dashin/sinatra-heroku-template.git
    mv sinatra-heroku-template YOUR_PROJECT_NAME
    heroku create YOUR_PROJECT_NAME
    cd YOUR_PROJECT_NAME
    git remote add heroku git@heroku.com:YOUR_PROJECT_NAME.git
    git push heroku master
    git remote rm origin    


That's all. Isn't simple?