# Yay production
environment 'production'

# This is a job for systemd
daemonize false

# We already have logs from Nginx and Rails
quiet

# Do not forget to create /run/korbjagd-api
bind 'unix:///run/korbjagd-api/puma.sock'
