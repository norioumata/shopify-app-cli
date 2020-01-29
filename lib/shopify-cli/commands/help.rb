require 'shopify_cli'

module ShopifyCli
  module Commands
    class Help < ShopifyCli::Command
      def call(args, _name)
        command = args.shift
        if command && command != 'help'
          if Registry.exist?(command)
            cmd, _name = Registry.lookup_command(command)
            output = cmd.help
            if cmd.respond_to?(:extended_help)
              output += "\n"
              output += cmd.extended_help
            end
          end

          @ctx.page(output)
          true
        else
          @ctx.puts("Command #{command} not found.")
          false
        end
      end

      def call_help_on_all_commands_in_registry
        # a line break before output aids scanning/readability
        puts ""
        @ctx.puts('{{bold:Available commands}}')
        @ctx.puts('Use {{command:shopify help [command]}} to display detailed information about a specific command.')
        puts ""

        # need to do this once to allow contextual commands to update the command registry
        ShopifyCli::Commands::Registry.resolved_commands

        ShopifyCli::Commands::Registry.resolved_commands.sort.each do |name, klass|
          next if name == 'help' || klass.nil?
          puts CLI::UI.fmt("{{command:#{ShopifyCli::TOOL_NAME} #{name}}}")
          while (klass.has_more_context?)
            klass.register_contextual_command
            klass, name = Registry.lookup_command(name)
          end

          if (help = klass.help)
            puts CLI::UI.fmt(help)
          end

          puts ""
        end
      end
    end
  end
end
