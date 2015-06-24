module DPL
  class Provider
    class Transifex < Provider
      experimental 'Transifex'

      DEFAULT_CLIENT_VERSION = '>=0.11'
      DEFAULT_HOSTNAME = 'https://www.transifex.com'

      def install_deploy_dependencies
        self.class.pip 'transifex', 'transifex', options[:cli_version] || DEFAULT_CLIENT_VERSION
      end

      def needs_key?
        false
      end

      def check_auth
        install_deploy_dependencies
        write_transifexrc
        context.shell 'tx status'
      end

      def push_app
        source_push
      end

      private

      def write_transifexrc
        File.open(File.expand_path('~/.transifexrc'), 'w') do |f|
          f.puts <<-EOF.gsub(/^ {12}/, '')
            [#{options[:hostname] || DEFAULT_HOSTNAME}]
            hostname = #{options[:hostname] || DEFAULT_HOSTNAME}
            username = #{options[:username]}
            password = #{options[:password]}
            token = #{options[:token]}
          EOF
        end
      end

      def source_push
        context.shell 'tx push --source --no-interactive', retry: true
      end
    end
  end
end
