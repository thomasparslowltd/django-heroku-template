Tom's Django Template
=====================

This is a template for my own use for quick apps to stick on Heroku.
  
It almost certainly isn't the best for whatever you want, and I don't use it myself for larger projects.

Read these commands before you run them, don't be an idiot :)

Requires `gsed` (`brew install gsed`), `git`, `pip`,`virtualenv`,`virtualenvwrapper`,`heroku` etc

```
export APPNAME=realappname
git clone git@github.com:thomasparslowltd/toms-django-template.git $APPNAME
cd $APPNAME
git checkout -b master
gsed -i s/TODO_SECRET_KEY/`head -c1000 /dev/random  | md5`-`head -c1000 /dev/random  | md5`/ sites/MYAPPNAMEsite/settings.py
gsed -i s/TODO_DB_PASSWORD/`head -c1000 /dev/random  | md5`-`head -c1000 /dev/random  | md5`/ sites/MYAPPNAMEsite/settings.py
gsed -i s/TODO_SUPERVISOR_PASSWORD/`head -c1000 /dev/random  | md5`-`head -c1000 /dev/random  | md5`/ fabfile.py
find . -iname '*.py' | xargs gsed -i "s/MYAPPNAME/$APPNAME/"
gsed -i "s/MYAPPNAME/$APPNAME/" package.json .env
git mv apps/MYAPPNAME apps/$APPNAME
git mv apps/$APPNAME/templates/MYAPPNAME apps/$APPNAME/templates/$APPNAME
#cp sites/${APPNAME}site/local_settings.py.example sites/${APPNAME}site/local_settings.py
git mv sites/MYAPPNAMEsite sites/${APPNAME}site
git commit -am "Replace placeholder name with actual project name"
mkvirtualenv ~/envs/$APPNAME
workon $APPNAME
echo "workon $APPNAME" > .env
git add .env
git commit -am "Added a .env file for autoenv"
pip install -r requirements.txt
heroku apps:create $APPNAME
heroku config:add BUILDPACK_URL=https://github.com/heroku/heroku-buildpack-python
git push heroku master
heroku run 'python manage.py syncdb --migrate'
git remote rename origin template
```

If you add AWS credentials to the settings.py and set up the correct bucket names etc you can run `python manage collectstatic` to upload your static files to S3.
