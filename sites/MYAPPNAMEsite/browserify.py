from pipeline.compilers import SubProcessCompiler
from django.conf import settings

class BrowserifyCompiler(SubProcessCompiler):
  output_extension = 'bundled.js'

  def match_file(self, filename):
    return filename.endswith('.js')

  def compile_file(self, infile, outfile, outdated=False, force=False):
    # print outdated, force
    # if not outdated and not force:
    #   return  # No need to recompiled file

    command = "%s %s %s > %s" % (
        settings.PIPELINE_BROWSERIFY_SCRIPT_BINARY,
        settings.PIPELINE_BROWSERIFY_SCRIPT_ARGUMENTS,
        infile,
        outfile
        )
    return self.execute_command(command) 
