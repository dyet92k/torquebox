# Copyright 2014 Red Hat, Inc, and individual contributors.
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

require "spec_helper"

feature "embedded sockjs example" do
  embedded("main.rb", :dir => "#{apps_dir}/embedded/sockjs_echo")

  it "should register the rack app" do
    visit "/"
    page.should have_content("sockjs echo example")
  end

  it "should register the sockjs endpoint" do
    visit "/echo"
    page.should have_content("Welcome to SockJS!")
  end

  it "should attempt websocket upgrade" do
    uri = URI.parse("#{Capybara.app_host}/echo/websocket")
    Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Get.new(uri.request_uri)
      request.add_field("Upgrade", "websocket")
      request.add_field("Connection", "Upgrade")
      request.add_field("Sec-WebSocket-Key", "x3JJHMbDL1EzLkh9GBhXDw==")
      request.add_field("Sec-WebSocket-Version", "13")
      response = http.request(request)
      response.code.should == "101"
      response["Sec-WebSocket-Accept"].should_not be_nil
    end
  end
end
