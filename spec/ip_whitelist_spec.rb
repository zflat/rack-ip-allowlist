require 'spec_helper'

module Rack
  describe IpWhitelist do
    let(:app){ ->(env) { [200, env, "app"] }}
    
    context "Given no whitelist info" do
      let(:middleware) do
        IpWhitelist.new(app)
      end
      
      it "is unauthorized" do
        code, env = middleware.call env_for('http://admin.example.com', 'REMOTE_ADDR'=>'192.168.100.2')
        expect(code).to eq 403
      end
      
    end # context "no whitelist info" do
    
    context "Given a list addresses" do
      let(:listed_ip){'127.0.0.1'}
      let(:ip_list){ "#{listed_ip},55.44.11.22"}

      let(:middleware) do
        IpWhitelist.new(app, ip_list)
      end
      
      context "A request from listed ip" do
        it "allows the IP" do
          code, env = middleware.call env_for('http://admin.example.com', 'REMOTE_ADDR'=>listed_ip)
          expect(code).to eq 200
        end
      end # context "request from listed ip"

      context "A request from unlisted ip" do
        it "is unauthorized" do
          code, env = middleware.call env_for('http://admin.example.com', 'REMOTE_ADDR'=>'192.168.100.2')
          expect(code).to eq 403
        end
      end
      
    end # context "given an array of addresses" do
    
  end # describe IpWhitelist
end # module Rack
