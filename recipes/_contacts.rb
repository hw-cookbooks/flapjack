#
# Cookbook:: flapjack
# Recipe:: _contacts
#
# Copyright:: 2014, Heavy Water Operations, LLC.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

data_bag_name = node['flapjack']['contacts']['data_bag']['name']

contact_items = data_bag(data_bag_name).map do |item|
  data_bag_item(data_bag_name, item).to_hash
end

contact_namespace = node['flapjack']['contacts']['data_bag']['namespace']

contacts = case contact_namespace
           when nil
             contact_items
           else
             contact_items.map { |item| item[contact_namespace] }.compact
           end

contacts.each do |contact|
  resource_action = contact.delete('action') || 'create'
  flapjack_contact contact['id'] do
    info contact
    action resource_action.to_sym
  end
end

if node['flapjack']['contacts']['manage_all_entity']
  contact_ids = contacts.map { |contact| contact['id'] }
  flapjack_entity 'ALL' do
    info(name: 'ALL', contacts: contact_ids)
  end
end
