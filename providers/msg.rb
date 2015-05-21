action :speak do
  require 'hipchat'
  begin
    client = HipChat::Client.new(
      @new_resource.token,
      :api_version => @new_resource.api_version,
      :server_url => @new_resource.server
    )
    message = @new_resource.message || @new_resource.name
    client[@new_resource.room].send(@new_resource.nickname,
                                    message,
                                    :notify => @new_resource.notify,
                                    :color => @new_resource.color,
                                    :message_format => @new_resource.message_format)
  rescue => e
      if @new_resource.failure_ok
        Chef::Log.info("HipChat: failed to connect to HipChat.")
        Chef::Log.debug("HipChat: #{e.inspect}")
      else
        Chef::Log.fatal("HipChat: failed to connect to HipChat.")
        Chef::Log.fatal("HipChat: #{e.inspect}")
        raise
      end
  end
  new_resource.updated_by_last_action(true)
end
