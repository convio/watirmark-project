class SVNClient

  def initialize project_name, path_to_project
    #auth
    @username = nil
    @password = nil

    #project info
    @project_name = project_name
    @project_path = path_to_project
    @repository_url = "http://scm.corp.convio.com/svn/convio/ecrm/trunk/watir-projects/#{project_name}"

    #external urls
    @sf_external = "http://scm.corp.convio.com/svn/convio/cg-enterprise/trunk/watir/cg-enterprise/lib lib"
    @clo_external = "http://scm.corp.convio.com/svn/convio/ecrm/trunk/watir/crm/lib lib"
    @cla_external = "http://scm.corp.convio.com/svn/convio/cma/trunk/qa/watir/cla/lib lib"
    @step_def_external= "http://scm.corp.convio.com/svn/convio/ecrm/trunk/watir/crm/steps clo\n" +
                        "http://scm.corp.convio.com/svn/convio/cg-enterprise/trunk/watir/cg-enterprise/steps crm\n" +
                        "http://scm.corp.convio.com/svn/convio/ecrm/trunk/watir/crm/service_bus/steps bus"
  end

  #assumes project scaffolding has already run.
  #will svn import skeleton project, set externals,
  #and commit.
  def project_setup
    import @project_path, @repository_url
    rm @project_path
    checkout @repository_url, @project_path
    set_external @sf_external, @project_path+"/sf"
    set_external @clo_external, @project_path+"/clo"
    set_external @cla_external, @project_path+"/cla"
    set_external @step_def_external, @project_path+"/features/step_definitions"
    commit @project_path, "Commit of #{@project_name} with externals to all product libs and step definitions."
  end

  private

  def checkout url, dest_path
    raise Exception, "checkout failed" if !system("svn checkout #{url} #{dest_path}")
  end

  def import path, url
    raise Exception, "import failed" if !system("svn import -m \"Project skeleton commit\" #{path} #{url}")
  end

  def commit path, msg
    raise Exception, "commit failed" if !system("svn commit #{path} -m \"#{msg}\"")
  end

  def set_external propval, path_to_dir
    raise Exception, "propset failed" if !system("svn propset svn:externals \"#{propval}\" #{path_to_dir}")
  end

  def rm dir
    raise Exception, "rmdir failed" if !system("rmdir /S /Q #{dir}")
  end

end