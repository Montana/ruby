require 'spec_helper'



describe "#subscribe" do
  before(:each) do
    @response_output = StringIO.new
    @message_output = StringIO.new

    @callback = lambda { |envelope|
      $logger.debug 'FIRING CALLBACK FROM TEST'
      @response_output.write envelope.response
      @message_output.write envelope.msg
      @after_callback = true
      if EM.reactor_running? && envelope.is_last?
        EM.stop
      end
    }

    @error_callback = lambda { |envelope|
      $logger.debug 'FIRING ERROR CALLBACK FROM TEST'
      @response_output.write envelope.response
      @message_output.write envelope.msg
      @after_error_callback = true
      if EM.reactor_running? && envelope.is_last?
        EM.stop
      end
    }

    @pn = Pubnub.new(:max_retries => 0, :subscribe_key => :demo, :publish_key => :demo, :auth_key => :demoish_authkey, :secret_key => 'some_secret_key', :error_callback => @error_callback)
    @pn.uuid = 'rubytests'

  end
  context "uses ssl" do
    before(:each) { @ssl = true }
    context "passess callback as block" do
      context "gets valid json in response" do
        context "gets status 200 in response" do
          context "uses sync connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-ssl-block-valid-200-sync", :record => :none) do
                @pn.subscribe(:ssl => true, :http_sync => true, :channel => "demo", &@callback)
                @pn.subscribe(:ssl => true, :http_sync => true, :channel => "demo", &@callback)
                while EM.reactor_running? do
                end
                @after_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"13904299332319098"][[{"text":"hey"},{"text":"hey"}],"13904299332319098"]'
                @message_output.seek 0
                @message_output.read.should eq '{"text"=>"hey"}{"text"=>"hey"}'
              end
            end
          end
          context "uses async connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-ssl-block-valid-200-async", :record => :none) do
                @pn.subscribe(:ssl => true, :http_sync => false, :channel => "demo", &@callback)
                while EM.reactor_running? do
                end
                @after_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"13904299332319098"][[{"text":"hey"},{"text":"hey"}],"13904299332319098"]'
                @message_output.seek 0
                @message_output.read.should eq '{"text"=>"hey"}{"text"=>"hey"}'
              end
            end
          end
        end
        context "gets status non-200 in response" do
          context "uses sync connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-ssl-block-valid-non-200-sync", :record => :none) do
                @pn.subscribe(:ssl => true, :http_sync => true, :channel => "demo", &@callback)
                @pn.subscribe(:ssl => true, :http_sync => true, :channel => "demo", &@callback)
                while EM.reactor_running? do
                end
                @after_error_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"13904299332319098"]'
                @message_output.seek 0
                @message_output.read.should eq '[0,"Non 2xx server response"]'
              end
            end
          end
          context "uses async connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-ssl-block-valid-non-200-async", :record => :none) do
                @pn.subscribe(:ssl => true, :http_sync => false, :channel => "demo", &@callback)
                while EM.reactor_running? do
                end
                @after_error_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"13904299332319098"]'
                @message_output.seek 0
                @message_output.read.should eq '[0,"Non 2xx server response"]'
              end
            end
          end
        end
      end
      context "gets invalid json in response" do
        context "gets status 200 in response" do
          context "uses sync connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-ssl-block-invalid-200-sync", :record => :none) do
                @pn.subscribe(:ssl => true, :http_sync => true, :channel => "demo", &@callback)
                @pn.subscribe(:ssl => true, :http_sync => true, :channel => "demo", &@callback)
                while EM.reactor_running? do
                end
                @after_error_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"'
                @message_output.seek 0
                @message_output.read.should eq '[0,"Invalid JSON in response."]'
              end
            end
          end
          context "uses async connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-ssl-block-invalid-200-async", :record => :none) do
                @pn.subscribe(:ssl => true, :http_sync => false, :channel => "demo", &@callback)
                while EM.reactor_running? do
                end
                @after_error_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"'
                @message_output.seek 0
                @message_output.read.should eq '[0,"Invalid JSON in response."]'
              end
            end
          end
        end
        context "gets status non-200 in response" do
          context "uses sync connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-ssl-block-invalid-non-200-sync", :record => :none) do
                @pn.subscribe(:ssl => true, :http_sync => true, :channel => "demo", &@callback)
                @pn.subscribe(:ssl => true, :http_sync => true, :channel => "demo", &@callback)
                while EM.reactor_running? do
                end
                @after_error_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"'
                @message_output.seek 0
                @message_output.read.should eq '[0,"Invalid JSON in response."]'
              end
            end
          end
          context "uses async connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-ssl-block-invalid-non-200-async", :record => :none) do
                @pn.subscribe(:ssl => true, :http_sync => false, :channel => "demo", &@callback)
                while EM.reactor_running? do
                end
                @after_error_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"'
                @message_output.seek 0
                @message_output.read.should eq '[0,"Invalid JSON in response."]'
              end
            end
          end
        end
      end
    end
    context "passess callback as parameter" do
      context "gets valid json in response" do
        context "gets status 200 in response" do
          context "uses sync connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-ssl-parameter-valid-200-sync", :record => :none) do
                @pn.subscribe(:ssl => true, :http_sync => true, :channel => "demo", :callback => @callback)
                @pn.subscribe(:ssl => true, :http_sync => true, :channel => "demo", :callback => @callback)
                while EM.reactor_running? do
                end
                @after_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"13904299332319098"][[{"text":"hey"},{"text":"hey"}],"13904299332319098"]'
                @message_output.seek 0
                @message_output.read.should eq '{"text"=>"hey"}{"text"=>"hey"}'
              end
            end
          end
          context "uses async connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-ssl-parameter-valid-200-async", :record => :none) do
                @pn.subscribe(:ssl => true, :http_sync => false, :channel => "demo", :callback => @callback)
                while EM.reactor_running? do
                end
                @after_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"13904299332319098"][[{"text":"hey"},{"text":"hey"}],"13904299332319098"]'
                @message_output.seek 0
                @message_output.read.should eq '{"text"=>"hey"}{"text"=>"hey"}'
              end
            end
          end
        end
        context "gets status non-200 in response" do
          context "uses sync connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-ssl-parameter-valid-non-200-sync", :record => :none) do
                @pn.subscribe(:ssl => true, :http_sync => true, :channel => "demo", :callback => @callback)
                @pn.subscribe(:ssl => true, :http_sync => true, :channel => "demo", :callback => @callback)
                while EM.reactor_running? do
                end
                @after_error_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"13904299332319098"]'
                @message_output.seek 0
                @message_output.read.should eq '[0,"Non 2xx server response"]'
              end
            end
          end
          context "uses async connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-ssl-parameter-valid-non-200-async", :record => :none) do
                @pn.subscribe(:ssl => true, :http_sync => false, :channel => "demo", :callback => @callback)
                while EM.reactor_running? do
                end
                @after_error_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"13904299332319098"]'
                @message_output.seek 0
                @message_output.read.should eq '[0,"Non 2xx server response"]'
              end
            end
          end
        end
      end
      context "gets invalid json in response" do
        context "gets status 200 in response" do
          context "uses sync connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-ssl-parameter-invalid-200-sync", :record => :none) do
                @pn.subscribe(:ssl => true, :http_sync => true, :channel => "demo", :callback => @callback)
                @pn.subscribe(:ssl => true, :http_sync => true, :channel => "demo", :callback => @callback)
                while EM.reactor_running? do
                end
                @after_error_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"'
                @message_output.seek 0
                @message_output.read.should eq '[0,"Invalid JSON in response."]'
              end
            end
          end
          context "uses async connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-ssl-parameter-invalid-200-async", :record => :none) do
                @pn.subscribe(:ssl => true, :http_sync => false, :channel => "demo", :callback => @callback)
                while EM.reactor_running? do
                end
                @after_error_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"'
                @message_output.seek 0
                @message_output.read.should eq '[0,"Invalid JSON in response."]'
              end
            end
          end
        end
        context "gets status non-200 in response" do
          context "uses sync connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-ssl-parameter-invalid-non-200-sync", :record => :none) do
                @pn.subscribe(:ssl => true, :http_sync => true, :channel => "demo", :callback => @callback)
                @pn.subscribe(:ssl => true, :http_sync => true, :channel => "demo", :callback => @callback)
                while EM.reactor_running? do
                end
                @after_error_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"'
                @message_output.seek 0
                @message_output.read.should eq '[0,"Invalid JSON in response."]'
              end
            end
          end
          context "uses async connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-ssl-parameter-invalid-non-200-async", :record => :none) do
                @pn.subscribe(:ssl => true, :http_sync => false, :channel => "demo", :callback => @callback)
                while EM.reactor_running? do
                end
                @after_error_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"'
                @message_output.seek 0
                @message_output.read.should eq '[0,"Invalid JSON in response."]'
              end
            end
          end
        end
      end
    end
  end
  context "uses non-ssl" do
    before(:each) { @ssl = false }
    context "passess callback as block" do
      context "gets valid json in response" do
        context "gets status 200 in response" do
          context "uses sync connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-nonssl-block-valid-200-sync", :record => :none) do
                @pn.subscribe(:ssl => false, :http_sync => true, :channel => "demo", &@callback)
                @pn.subscribe(:ssl => false, :http_sync => true, :channel => "demo", &@callback)
                while EM.reactor_running? do
                end
                @after_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"13904299332319098"][[{"text":"hey"},{"text":"hey"}],"13904299332319098"]'
                @message_output.seek 0
                @message_output.read.should eq '{"text"=>"hey"}{"text"=>"hey"}'
              end
            end
          end
          context "uses async connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-nonssl-block-valid-200-async", :record => :none) do
                @pn.subscribe(:ssl => false, :http_sync => false, :channel => "demo", &@callback)
                while EM.reactor_running? do
                end
                @after_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"13904299332319098"][[{"text":"hey"},{"text":"hey"}],"13904299332319098"]'
                @message_output.seek 0
                @message_output.read.should eq '{"text"=>"hey"}{"text"=>"hey"}'
              end
            end
          end
        end
        context "gets status non-200 in response" do
          context "uses sync connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-nonssl-block-valid-non-200-sync", :record => :none) do
                @pn.subscribe(:ssl => false, :http_sync => true, :channel => "demo", &@callback)
                @pn.subscribe(:ssl => false, :http_sync => true, :channel => "demo", &@callback)
                while EM.reactor_running? do
                end
                @after_error_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"13904299332319098"]'
                @message_output.seek 0
                @message_output.read.should eq '[0,"Non 2xx server response"]'
              end
            end
          end
          context "uses async connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-nonssl-block-valid-non-200-async", :record => :none) do
                @pn.subscribe(:ssl => false, :http_sync => false, :channel => "demo", &@callback)
                while EM.reactor_running? do
                end
                @after_error_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"13904299332319098"]'
                @message_output.seek 0
                @message_output.read.should eq '[0,"Non 2xx server response"]'
              end
            end
          end
        end
      end
      context "gets invalid json in response" do
        context "gets status 200 in response" do
          context "uses sync connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-nonssl-block-invalid-200-sync", :record => :none) do
                @pn.subscribe(:ssl => false, :http_sync => true, :channel => "demo", &@callback)
                @pn.subscribe(:ssl => false, :http_sync => true, :channel => "demo", &@callback)
                while EM.reactor_running? do
                end
                @after_error_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"'
                @message_output.seek 0
                @message_output.read.should eq '[0,"Invalid JSON in response."]'
              end
            end
          end
          context "uses async connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-nonssl-block-invalid-200-async", :record => :none) do
                @pn.subscribe(:ssl => false, :http_sync => false, :channel => "demo", &@callback)
                while EM.reactor_running? do
                end
                @after_error_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"'
                @message_output.seek 0
                @message_output.read.should eq '[0,"Invalid JSON in response."]'
              end
            end
          end
        end
        context "gets status non-200 in response" do
          context "uses sync connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-nonssl-block-invalid-non-200-sync", :record => :none) do
                @pn.subscribe(:ssl => false, :http_sync => true, :channel => "demo", &@callback)
                @pn.subscribe(:ssl => false, :http_sync => true, :channel => "demo", &@callback)
                while EM.reactor_running? do
                end
                @after_error_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"'
                @message_output.seek 0
                @message_output.read.should eq '[0,"Invalid JSON in response."]'
              end
            end
          end
          context "uses async connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-nonssl-block-invalid-non-200-async", :record => :none) do
                @pn.subscribe(:ssl => false, :http_sync => false, :channel => "demo", &@callback)
                while EM.reactor_running? do
                end
                @after_error_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"'
                @message_output.seek 0
                @message_output.read.should eq '[0,"Invalid JSON in response."]'
              end
            end
          end
        end
      end
    end
    context "passess callback as parameter" do
      context "gets valid json in response" do
        context "gets status 200 in response" do
          context "uses sync connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-nonssl-parameter-valid-200-sync", :record => :none) do
                @pn.subscribe(:ssl => false, :http_sync => true, :channel => "demo", :callback => @callback)
                @pn.subscribe(:ssl => false, :http_sync => true, :channel => "demo", :callback => @callback)
                while EM.reactor_running? do
                end
                @after_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"13904299332319098"][[{"text":"hey"},{"text":"hey"}],"13904299332319098"]'
                @message_output.seek 0
                @message_output.read.should eq '{"text"=>"hey"}{"text"=>"hey"}'
              end
            end
          end
          context "uses async connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-nonssl-parameter-valid-200-async", :record => :none) do
                @pn.subscribe(:ssl => false, :http_sync => false, :channel => "demo", :callback => @callback)
                while EM.reactor_running? do
                end
                @after_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"13904299332319098"][[{"text":"hey"},{"text":"hey"}],"13904299332319098"]'
                @message_output.seek 0
                @message_output.read.should eq '{"text"=>"hey"}{"text"=>"hey"}'
              end
            end
          end
        end
        context "gets status non-200 in response" do
          context "uses sync connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-nonssl-parameter-valid-non-200-sync", :record => :none) do
                @pn.subscribe(:ssl => false, :http_sync => true, :channel => "demo", :callback => @callback)
                @pn.subscribe(:ssl => false, :http_sync => true, :channel => "demo", :callback => @callback)
                while EM.reactor_running? do
                end
                @after_error_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"13904299332319098"]'
                @message_output.seek 0
                @message_output.read.should eq '[0,"Non 2xx server response"]'
              end
            end
          end
          context "uses async connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-nonssl-parameter-valid-non-200-async", :record => :none) do
                @pn.subscribe(:ssl => false, :http_sync => false, :channel => "demo", :callback => @callback)
                while EM.reactor_running? do
                end
                @after_error_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"13904299332319098"]'
                @message_output.seek 0
                @message_output.read.should eq '[0,"Non 2xx server response"]'
              end
            end
          end
        end
      end
      context "gets invalid json in response" do
        context "gets status 200 in response" do
          context "uses sync connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-nonssl-parameter-invalid-200-sync", :record => :none) do
                @pn.subscribe(:ssl => false, :http_sync => true, :channel => "demo", :callback => @callback)
                @pn.subscribe(:ssl => false, :http_sync => true, :channel => "demo", :callback => @callback)
                while EM.reactor_running? do
                end
                @after_error_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"'
                @message_output.seek 0
                @message_output.read.should eq '[0,"Invalid JSON in response."]'
              end
            end
          end
          context "uses async connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-nonssl-parameter-invalid-200-async", :record => :none) do
                @pn.subscribe(:ssl => false, :http_sync => false, :channel => "demo", :callback => @callback)
                while EM.reactor_running? do
                end
                @after_error_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"'
                @message_output.seek 0
                @message_output.read.should eq '[0,"Invalid JSON in response."]'
              end
            end
          end
        end
        context "gets status non-200 in response" do
          context "uses sync connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-nonssl-parameter-invalid-non-200-sync", :record => :none) do
                @pn.subscribe(:ssl => false, :http_sync => true, :channel => "demo", :callback => @callback)
                @pn.subscribe(:ssl => false, :http_sync => true, :channel => "demo", :callback => @callback)
                while EM.reactor_running? do
                end
                @after_error_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"'
                @message_output.seek 0
                @message_output.read.should eq '[0,"Invalid JSON in response."]'
              end
            end
          end
          context "uses async connection" do
            it 'works fine' do
              VCR.use_cassette("subscribe-nonssl-parameter-invalid-non-200-async", :record => :none) do
                @pn.subscribe(:ssl => false, :http_sync => false, :channel => "demo", :callback => @callback)
                while EM.reactor_running? do
                end
                @after_error_callback.should eq true
                @response_output.seek 0
                @response_output.read.should eq '[[{"text":"hey"},{"text":"hey"}],"'
                @message_output.seek 0
                @message_output.read.should eq '[0,"Invalid JSON in response."]'
              end
            end
          end
        end
      end
    end
  end
end