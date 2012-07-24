class SVNClient

  def initialize project_name, path_to_project
    #auth
    @username = nil
    @password = nil

    #project info
    @project_name = project_name
    @project_path = path_to_project
    @working_copy_path = nil #hopefully dont need this

    #external urls
    @sf_external = "lib http://scm.corp.convio.com/svn/convio/cg-enterprise/trunk/watir/cg-enterprise/lib"
    @clo_external = "lib http://scm.corp.convio.com/svn/convio/ecrm/trunk/watir/crm/lib"
    @cla_external = "lib http://scm.corp.convio.com/svn/convio/cma/trunk/qa/watir/cla/lib"
    @step_def_clo_external= "clo ^/ecrm/trunk/watir/crm/steps"
    @step_def_sf_external= "crm ^/cg-enterprise/trunk/watir/cg-enterprise/steps"
    @step_def_sb_external= "bus ^/ecrm/trunk/watir/crm/service_bus/steps"
  end

  #assumes project scaffolding has already run.
  #will add skeleton project, set externals,
  #and commit.
  def project_setup
    import @project_path, @repository_url
    #need to recheckout here unless i can declare imported dir a working copy somehow
    set_external @sf_external, @project_path+"/sf"
    set_external @clo_external, @project_path+"/clo"
    set_external @cla_external, @project_path+"/cla"
    set_external @step_def_clo_external, @project_path+"/features/step_definitions"
    set_external @step_def_sf_external, @project_path+"/features/step_definitions"
    set_external @step_def_sb_external, @project_path+"/features/step_definitions"
    commit @project_path, "Commit of #{@project_name} with externals to all product libs and step definitions."
  end

  private

  def import path, url
    `svn import -m "Project skeleton commit" #{path} #{url}`
  end

  def commit path, msg
    `svn commit #{path} -m #{msg}`
  end

  def propset propval, path_to_dir
    `svn propset svn:external "#{propval}" #{path_to_dir}`
  end

end