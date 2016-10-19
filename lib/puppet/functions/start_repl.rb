begin
  require 'puppet-repl'
rescue LoadError => e
    Puppet.err('You must install the puppet-repl gem')
end

Puppet::Functions.create_function(:start_repl, Puppet::Functions::InternalFunction) do
  # the function below is called by puppet and and must match
  # the name of the puppet function above.
  dispatch :start_repl do
    scope_param
    optional_param 'Hash', :options
  end

  def start_repl(scope, options = {})
    if $stdout.isatty
      options = options.merge({:scope => scope})
      # forking the process allows us to start a new repl shell
      # for each occurrence of the start_repl function
      pid = fork do
        ::PuppetRepl::Cli.start(options)
      end
      Process.wait(pid)
    else
     Puppet.warning 'start_repl(): refusing to start the debugger on a daemonized master'
    end
  end
end
