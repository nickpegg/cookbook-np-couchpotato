default[:np_couchpotato].tap do |cp|
  cp[:install_path] = '/opt/couchpotato'
  cp[:install_method] = 'source'

  cp[:system_user] = 'couchpotato'
  cp[:system_group] = 'usenet'

  # Web interface username
  cp[:username] = 'couchpotato'

  cp[:port] = 5050

  # Source install settings
  cp[:repo] = 'https://github.com/CouchPotato/CouchPotatoServer.git'
  cp[:ref] = 'master'

  ### NOTE: The below attributes aren't used yet, will be if I write a configure recipe
  # renaming settings
  cp[:renamer].tap do |r|
    r[:from] = '/var/lib/usenet/downloads' # TODO: figure out default sab download location
    r[:to] = '/var/lib/movies'
  end

  # sabznbd+ settings
  cp[:sabznbd_plus].tap do |sab|
    sab[:enable] = false

    sab[:host] = 'localhost'
    sab[:port] = 8080
    sab[:category] = 'movies'

    # Data bag item to pull sabznbd API key from
    sab[:api_key][:data_bag]      = 'couchpotato'
    sab[:api_key][:data_bag_item] = 'secrets'
  end
end
