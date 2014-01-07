Tom's Django Template
=====================

This is a template for my own use for quick apps to stick on Heroku.

It almost certainly isn't the best for whatever you want, and I don't use it myself for larger projects.

Setup process
=============


Read these commands before you run them, don't be an idiot :)

Requires `gsed` (`brew install gsed`), `git`, `pip`,`virtualenv`,`virtualenvwrapper`,`heroku` etc

```
export APPNAME=realappname
git clone git@github.com:thomasparslowltd/django-heroku-template.git $APPNAME
cd $APPNAME
git checkout -b master
gsed -i s/TODO_SECRET_KEY/`head -c1000 /dev/random  | md5`-`head -c1000 /dev/random  | md5`/ MYAPPNAME/settings.py
find . -iname '*.py' | xargs gsed -i "s/MYAPPNAME/$APPNAME/"
git mv MYAPPNAME $APPNAME
git mv $APPNAME/templates/MYAPPNAME $APPNAME/templates/$APPNAME
git commit -am "Replace placeholder name with actual project name"
mkvirtualenv ~/envs/$APPNAME
workon $APPNAME
echo "workon $APPNAME" > .env
git add .env
git commit -am "Added a .env file for autoenv"
cp $APPNAME/local_settings.py.example $APPNAME/local_settings.py
pip install -r requirements.txt
heroku apps:create $APPNAME
git push heroku master
heroku run 'python manage.py syncdb --migrate'
git remote rename origin template
```

If you add AWS credentials to the settings.py and set up the correct bucket names etc you can run `python manage collectstatic` to upload your static files to S3.

