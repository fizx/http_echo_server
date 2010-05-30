require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

HttpEchoServer.start(9999)
describe "HttpEchoServer" do
  it "should echo the request" do
    open("http://localhost:9999/foo/bar").read.should == "GET /foo/bar HTTP/1.1\r\nAccept: */*\r\nHost: localhost:9999\r\n\r\n"
  end
end
