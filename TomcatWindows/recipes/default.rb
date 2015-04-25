#
# Cookbook Name:: TomcatWindows
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

#remote_directory "C:/App/Apache Group/Tomcat 8.0.21" do
#  inherits true
#  source "Tomcat8.0.21"
#end

#ruby windows_zipfile 'C:/Temp' do
#  source 'C:/Software/apache-tomcat-8.0.21-windows-x64.zip'
#  action :unzip
#end

ruby_block "get the windows resources" do
  block do
    FileUtils.mkdir_p "C:/App2"
    FileUtils.cp_r("C:/Software/Tomcat 8.0.21", "C:/App2")
  end
  not_if { File.exists?("C:/App2/Tomcat 8.0.21") && File.directory?("C:/App2/Tomcat 8.0.21") }
end
