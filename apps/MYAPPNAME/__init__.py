from __future__ import absolute_import

from .celery import app as celery_app
from celery.utils.log import get_task_logger
from . import models

logger = get_task_logger("MYAPPNAME.tasks")

# @app.task
# def do_stuff(argument):
#     logger.info("Doing stuff with %s" % (argument,))
