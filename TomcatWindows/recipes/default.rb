#
#  
#remote_directory "C:/App/Apache Group/Tomcat 8.0.21" do
#  inherits true
#  source "Tomcat8.0.21"

TomcatSource = node['TomcatWindows']['Software'] + 'Tomcat ' + node['TomcatWindows']['TomcatVersion']
ProgramFolder = node['TomcatWindows']['InstallDrive'] + '/App'
ApacheFolder = ProgramFolder + '/Apache Group'
CatalinaHost = ApacheFolder + "/Tomcat " + node['TomcatWindows']['TomcatVersion']
CatalinaBase = CatalinaHost + '/Instances/' + node['TomcatWindows']['AppInstanceName'] + '_' + node['TomcatWindows']['Environment']

raise if !(File.exists?(TomcatSource))
  
directory ProgramFolder do
  inherits true
  action :create
end

directory ApacheFolder do
  inherits true
  action :create
end

ruby_block "get the windows resources" do
  block do
    #FileUtils.mkdir_p "C:/App2"
    FileUtils.cp_r(TomcatSource, ApacheFolder)
  end
  not_if { File.exists?(CatalinaHost) && File.directory?(CatalinaHost) }
end

directory CatalinaHost + '/Instances' do
  inherits true
  action :create
end

directory CatalinaBase do
  inherits true
  action :create
end

