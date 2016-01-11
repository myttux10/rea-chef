require 'serverspec'

# Required by serverspec
set :backend, :exec

describe "nginx" do

  it "is listening on port 80" do
    expect(port(80)).to be_listening
  end

  it "service is runnin" do
    expect(service("nginx")).to be_running
  end

end
