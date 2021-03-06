#
# Author:: Sander Botman <sbotman@schubergphilis.com>
# Cookbook Name:: nagios
# Provider:: resourcelist_items
#
# Copyright 2015, Sander Botman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

action :update do
  run_context.resource_collection.each do |r|
    case r
    when Chef::Resource::NagiosCommand
      update_object(r, 'command', Nagios::Command)
    when Chef::Resource::NagiosContact
      update_object(r, 'contact', Nagios::Contact)
    when Chef::Resource::NagiosContactgroup
      update_object(r, 'contactgroup', Nagios::Contactgroup)
    when Chef::Resource::NagiosHost
      update_object(r, 'host', Nagios::Host)
    when Chef::Resource::NagiosHostdependency
      update_object(r, 'hostdependency', Nagios::Hostdependency)
    when Chef::Resource::NagiosHostescalation
      update_object(r, 'hostescalation', Nagios::Hostescalation)
    when Chef::Resource::NagiosHostgroup
      update_object(r, 'hostgroup', Nagios::Hostgroup)
    when Chef::Resource::NagiosResource
      update_object(r, 'resource', Nagios::Resource)
    when Chef::Resource::NagiosService
      update_object(r, 'service', Nagios::Service)
    when Chef::Resource::NagiosServicedependency
      update_object(r, 'servicedependency', Nagios::Servicedependency)
    when Chef::Resource::NagiosServiceescalation
      update_object(r, 'serviceescalation', Nagios::Serviceescalation)
    when Chef::Resource::NagiosServicegroup
      update_object(r, 'servicegroup', Nagios::Servicegroup)
    when Chef::Resource::NagiosTimeperiod
      update_object(r, 'timeperiod', Nagios::Timeperiod)
    end
  end
  new_resource.updated_by_last_action(false)
end

private

def isdelete?(action)
  if action.is_a?(Symbol)
    return true if action == :delete || action == :delete
  elsif action.is_a?(Array)
    return true if action.include?(:delete) || action.include?(:remove)
  else
    return false
  end
end

def update_object(obj, entry, type)
  if isdelete?(obj.action)
    Nagios.instance.delete(entry, obj.name)
  else
    o = type.create(obj.name)
    o.import(obj.options)
  end
end
