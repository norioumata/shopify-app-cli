require 'test_helper'

module ShopifyCli
  module Commands
    class OpenTest < MiniTest::Test
      def test_run
        Tasks::Tunnel.stubs(:call).returns('https://example.com')
        ShopifyCli::Context.any_instance.expects(:open_url!).with('https://example.com')
        run_cmd('open')
      end
    end
  end
end
