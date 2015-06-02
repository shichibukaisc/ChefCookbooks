#
#  
#remote_directory "C:/App/Apache Group/Tomcat 8.0.21" do
#  inherits true
#  source "Tomcat8.0.21"

TomcatSource = node['TomcatWindows']['Software'] + '/Tomcat ' + node['TomcatWindows']['TomcatVersion']
ProgramFolder = node['TomcatWindows']['InstallDrive'] + '/App'
ApacheFolder = ProgramFolder + '/Apache Group'
CatalinaHost = ApacheFolder + "/Tomcat " + node['TomcatWindows']['TomcatVersion']
CatalinaBase = CatalinaHost + '/Instances/' + node['TomcatWindows']['AppInstanceName'] + '_' + node['TomcatWindows']['Environment']

  
log "TomcatSource: #{TomcatSource}"
raise if !File.exists?(TomcatSource)

# Preparing Parent Root Directory
directory ProgramFolder do
  inherits true
  action :create
end

# Prepare Java Directory


# Preparing Apache Root Directory
directory ApacheFolder do
  inherits true
  action :create
end

#####################################################################################

#Preparing Tomcat Catalina Host directory

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

#####################################################################################

#Preparing Tomcat Catalina Base directory for specific application

directory CatalinaBase do
  inherits true
  action :create
end

directory CatalinaBase + '/webapps' do
  inherits true
  action :create
end

directory CatalinaBase + '/webapps/ROOT' do
  inherits true
  action :create
end

template "#{CatalinaBase}/webapps/index.html" do
  source "webapps/index.html.erb"
  inherits true
  action :create
end

directory CatalinaBase + '/logs' do
  inherits true
  action :create
end

directory CatalinaBase + '/lib' do
  inherits true
  action :create
end

directory CatalinaBase + '/temp' do
  inherits true
  action :create
end

directory CatalinaBase + '/work' do
  inherits true
  action :create
end

directory CatalinaBase + '/lib' do
  inherits true
  action :create
end

#####################################################################################

#Preparing Catalina Base Conf files

remote_file "Copy Catalina Policy Conf" do 
  path "#{CatalinaBase}/conf/catalina.policy" 
  source "file://#{CatalinaHost}/conf/catalina.policy"
  inherits true
end

template "#{CatalinaBase}/conf/catalina.properties" do
  source "#{node['TomcatWindows']['TomcatVersion']}/catalina.properties.erb"
  inherits true
  action :create
end

template "#{CatalinaBase}/conf/logging.properties" do
  source "#{node['TomcatWindows']['TomcatVersion']}/logging.properties.erb"
  inherits true
  action :create
end

template "#{CatalinaBase}/conf/server.xml" do
  source "#{node['TomcatWindows']['TomcatVersion']}/server.xml.erb"
  helper(:ShutdownPort) { "#{node['TomcatWindows']['PortPrefix']}03" }
  helper(:HttpPort) { "#{node['TomcatWindows']['PortPrefix']}00" }
  helper(:HttpsPort) { "#{node['TomcatWindows']['PortPrefix']}01" }
  helper(:AJPPort) { "#{node['TomcatWindows']['PortPrefix']}02" }
  inherits true
  action :create
end

template "#{CatalinaBase}/conf/logging.properties" do
  source "#{node['TomcatWindows']['TomcatVersion']}/logging.properties.erb"
  inherits true
  action :create
end


if File.exists?("#{CatalinaHost}/conf/tomcat-users.xsd")
  remote_file "Copy Tomcat User XSD" do 
    path "#{CatalinaBase}/conf/tomcat-users.xsd"
    source "file://#{CatalinaHost}/conf/tomcat-users.xsd"
    not_if { !File.exists?("#{CatalinaBase}/conf/tomcat-users.xsd")  }
    inherits true
    end
end



