require 'spec_helper'

module Rack
  describe IpAllowlist do
    let(:app){ ->(env) { [200, env, "app"] }}
    
    context "Given no allowlist info" do
      let(:middleware) do
        IpAllowlist.new(app)
      end
      
      it "is unauthorized" do
        code, env = middleware.call env_for('http://admin.example.com', 'REMOTE_ADDR'=>'192.168.100.2')
        expect(code).to eq 403
      end
      
    end # context "no allowlist info" do

    context "With wildcard ip addresses set in ENV" do
      let(:middleware) do
        IpAllowlist.new(app)
      end

      before :each do
        ENV['ALLOWLISTED_IPS'] = '*.*.*.*'
      end

      after :each do
        ENV['ALLOWLISTED_IPS'] = nil
      end

      it "is authorized" do
        code, env = middleware.call env_for('http://admin.example.com', 'REMOTE_ADDR'=>'192.168.100.2')
        expect(code).to_not eq 403
      end
    end # context "With wildcard ip addresses set in ENV"

    context "With a fake hostname set in ENV" do
      let(:middleware) do
        IpAllowlist.new(app)
      end

      before :each do
        ENV['ALLOWLISTED_HOSTNAMES'] = SecureRandom.hex(22)
      end

      after :each do
        ENV['ALLOWLISTED_HOSTNAMES'] = nil
      end

      it "blocks ip 127.0.0.1" do
        code, env = middleware.call env_for('http://admin.example.com', 'REMOTE_ADDR'=>'127.0.0.1')
        expect(code).to eq 403
      end
    end
    
    context "With 'localhost' hostname set in ENV" do
      let(:middleware) do
        IpAllowlist.new(app)
      end

      before :each do
        ENV['ALLOWLISTED_HOSTNAMES'] = 'localhost'
      end

      after :each do
        ENV['ALLOWLISTED_HOSTNAMES'] = nil
      end

      it "authorizes ip 127.0.0.1" do
        code, env = middleware.call env_for('http://admin.example.com', 'REMOTE_ADDR'=>'127.0.0.1')
        expect(code).to_not eq 403
      end
    end
    
    context "Given a list of ip addresses" do
      let(:listed_ip){'127.0.0.1'}
      let(:ip_list){ "#{listed_ip},55.44.11.22"}

      let(:middleware) do
        IpAllowlist.new(app, :ips=>ip_list)
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

    context "Given 'localhost' and 'rubygems.org' hostname" do
      let(:hostnames_list){'localhost,rubygems.org'}
      let(:middleware) do
        IpAllowlist.new(app, :hostnames=>hostnames_list)
      end

      before :each do
        ENV['ALLOWLISTED_HOSTNAMES'] = 'localhost'
      end

      after :each do
        ENV['ALLOWLISTED_HOSTNAMES'] = nil
      end

      it "authorizes ip 127.0.0.1" do
        code, env = middleware.call env_for('http://admin.example.com', 'REMOTE_ADDR'=>'127.0.0.1')
        expect(code).to_not eq 403
      end
    end
    
    
  end # describe IpAllowlist
end # module Rack
