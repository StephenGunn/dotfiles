# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.
function __fish_obs_cmd_global_optspecs
	string join \n w/websocket= h/help V/version
end

function __fish_obs_cmd_needs_command
	# Figure out if the current invocation already has a command.
	set -l cmd (commandline -opc)
	set -e cmd[1]
	argparse -s (__fish_obs_cmd_global_optspecs) -- $cmd 2>/dev/null
	or return
	if set -q argv[1]
		# Also print the command, so this can be used to figure out what it is.
		echo $argv[1]
		return 1
	end
	return 0
end

function __fish_obs_cmd_using_subcommand
	set -l cmd (__fish_obs_cmd_needs_command)
	test -z "$cmd"
	and return 1
	contains -- $cmd[1] $argv
end

complete -c obs-cmd -n "__fish_obs_cmd_needs_command" -s w -l websocket -d 'OBS WebSocket connection URL' -r
complete -c obs-cmd -n "__fish_obs_cmd_needs_command" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c obs-cmd -n "__fish_obs_cmd_needs_command" -s V -l version -d 'Print version'
complete -c obs-cmd -n "__fish_obs_cmd_needs_command" -f -a "info" -d 'Get OBS Studio version and information'
complete -c obs-cmd -n "__fish_obs_cmd_needs_command" -f -a "scene"
complete -c obs-cmd -n "__fish_obs_cmd_needs_command" -f -a "scene-collection"
complete -c obs-cmd -n "__fish_obs_cmd_needs_command" -f -a "profile"
complete -c obs-cmd -n "__fish_obs_cmd_needs_command" -f -a "video-settings"
complete -c obs-cmd -n "__fish_obs_cmd_needs_command" -f -a "stream-service"
complete -c obs-cmd -n "__fish_obs_cmd_needs_command" -f -a "record-directory"
complete -c obs-cmd -n "__fish_obs_cmd_needs_command" -f -a "replay"
complete -c obs-cmd -n "__fish_obs_cmd_needs_command" -f -a "virtual-camera"
complete -c obs-cmd -n "__fish_obs_cmd_needs_command" -f -a "streaming"
complete -c obs-cmd -n "__fish_obs_cmd_needs_command" -f -a "recording"
complete -c obs-cmd -n "__fish_obs_cmd_needs_command" -f -a "save-screenshot"
complete -c obs-cmd -n "__fish_obs_cmd_needs_command" -f -a "audio"
complete -c obs-cmd -n "__fish_obs_cmd_needs_command" -f -a "filter"
complete -c obs-cmd -n "__fish_obs_cmd_needs_command" -f -a "scene-item"
complete -c obs-cmd -n "__fish_obs_cmd_needs_command" -f -a "trigger-hotkey"
complete -c obs-cmd -n "__fish_obs_cmd_needs_command" -f -a "fullscreen-projector"
complete -c obs-cmd -n "__fish_obs_cmd_needs_command" -f -a "source-projector"
complete -c obs-cmd -n "__fish_obs_cmd_needs_command" -f -a "media-input"
complete -c obs-cmd -n "__fish_obs_cmd_needs_command" -f -a "input"
complete -c obs-cmd -n "__fish_obs_cmd_needs_command" -f -a "completion" -d 'Generate shell completion scripts'
complete -c obs-cmd -n "__fish_obs_cmd_needs_command" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand info" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and not __fish_seen_subcommand_from current switch list create remove rename transition-list transition-current transition-set transition-duration transition-trigger studio-mode-status studio-mode-enable studio-mode-disable studio-mode-toggle studio-mode-transition preview-current preview-set help" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and not __fish_seen_subcommand_from current switch list create remove rename transition-list transition-current transition-set transition-duration transition-trigger studio-mode-status studio-mode-enable studio-mode-disable studio-mode-toggle studio-mode-transition preview-current preview-set help" -f -a "current"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and not __fish_seen_subcommand_from current switch list create remove rename transition-list transition-current transition-set transition-duration transition-trigger studio-mode-status studio-mode-enable studio-mode-disable studio-mode-toggle studio-mode-transition preview-current preview-set help" -f -a "switch"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and not __fish_seen_subcommand_from current switch list create remove rename transition-list transition-current transition-set transition-duration transition-trigger studio-mode-status studio-mode-enable studio-mode-disable studio-mode-toggle studio-mode-transition preview-current preview-set help" -f -a "list"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and not __fish_seen_subcommand_from current switch list create remove rename transition-list transition-current transition-set transition-duration transition-trigger studio-mode-status studio-mode-enable studio-mode-disable studio-mode-toggle studio-mode-transition preview-current preview-set help" -f -a "create"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and not __fish_seen_subcommand_from current switch list create remove rename transition-list transition-current transition-set transition-duration transition-trigger studio-mode-status studio-mode-enable studio-mode-disable studio-mode-toggle studio-mode-transition preview-current preview-set help" -f -a "remove"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and not __fish_seen_subcommand_from current switch list create remove rename transition-list transition-current transition-set transition-duration transition-trigger studio-mode-status studio-mode-enable studio-mode-disable studio-mode-toggle studio-mode-transition preview-current preview-set help" -f -a "rename"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and not __fish_seen_subcommand_from current switch list create remove rename transition-list transition-current transition-set transition-duration transition-trigger studio-mode-status studio-mode-enable studio-mode-disable studio-mode-toggle studio-mode-transition preview-current preview-set help" -f -a "transition-list"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and not __fish_seen_subcommand_from current switch list create remove rename transition-list transition-current transition-set transition-duration transition-trigger studio-mode-status studio-mode-enable studio-mode-disable studio-mode-toggle studio-mode-transition preview-current preview-set help" -f -a "transition-current"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and not __fish_seen_subcommand_from current switch list create remove rename transition-list transition-current transition-set transition-duration transition-trigger studio-mode-status studio-mode-enable studio-mode-disable studio-mode-toggle studio-mode-transition preview-current preview-set help" -f -a "transition-set"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and not __fish_seen_subcommand_from current switch list create remove rename transition-list transition-current transition-set transition-duration transition-trigger studio-mode-status studio-mode-enable studio-mode-disable studio-mode-toggle studio-mode-transition preview-current preview-set help" -f -a "transition-duration"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and not __fish_seen_subcommand_from current switch list create remove rename transition-list transition-current transition-set transition-duration transition-trigger studio-mode-status studio-mode-enable studio-mode-disable studio-mode-toggle studio-mode-transition preview-current preview-set help" -f -a "transition-trigger"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and not __fish_seen_subcommand_from current switch list create remove rename transition-list transition-current transition-set transition-duration transition-trigger studio-mode-status studio-mode-enable studio-mode-disable studio-mode-toggle studio-mode-transition preview-current preview-set help" -f -a "studio-mode-status"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and not __fish_seen_subcommand_from current switch list create remove rename transition-list transition-current transition-set transition-duration transition-trigger studio-mode-status studio-mode-enable studio-mode-disable studio-mode-toggle studio-mode-transition preview-current preview-set help" -f -a "studio-mode-enable"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and not __fish_seen_subcommand_from current switch list create remove rename transition-list transition-current transition-set transition-duration transition-trigger studio-mode-status studio-mode-enable studio-mode-disable studio-mode-toggle studio-mode-transition preview-current preview-set help" -f -a "studio-mode-disable"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and not __fish_seen_subcommand_from current switch list create remove rename transition-list transition-current transition-set transition-duration transition-trigger studio-mode-status studio-mode-enable studio-mode-disable studio-mode-toggle studio-mode-transition preview-current preview-set help" -f -a "studio-mode-toggle"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and not __fish_seen_subcommand_from current switch list create remove rename transition-list transition-current transition-set transition-duration transition-trigger studio-mode-status studio-mode-enable studio-mode-disable studio-mode-toggle studio-mode-transition preview-current preview-set help" -f -a "studio-mode-transition"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and not __fish_seen_subcommand_from current switch list create remove rename transition-list transition-current transition-set transition-duration transition-trigger studio-mode-status studio-mode-enable studio-mode-disable studio-mode-toggle studio-mode-transition preview-current preview-set help" -f -a "preview-current"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and not __fish_seen_subcommand_from current switch list create remove rename transition-list transition-current transition-set transition-duration transition-trigger studio-mode-status studio-mode-enable studio-mode-disable studio-mode-toggle studio-mode-transition preview-current preview-set help" -f -a "preview-set"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and not __fish_seen_subcommand_from current switch list create remove rename transition-list transition-current transition-set transition-duration transition-trigger studio-mode-status studio-mode-enable studio-mode-disable studio-mode-toggle studio-mode-transition preview-current preview-set help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from current" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from switch" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from remove" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from rename" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from transition-list" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from transition-current" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from transition-set" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from transition-duration" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from transition-trigger" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from studio-mode-status" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from studio-mode-enable" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from studio-mode-disable" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from studio-mode-toggle" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from studio-mode-transition" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from preview-current" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from preview-set" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from help" -f -a "current"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from help" -f -a "switch"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from help" -f -a "list"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from help" -f -a "create"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from help" -f -a "remove"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from help" -f -a "rename"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from help" -f -a "transition-list"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from help" -f -a "transition-current"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from help" -f -a "transition-set"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from help" -f -a "transition-duration"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from help" -f -a "transition-trigger"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from help" -f -a "studio-mode-status"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from help" -f -a "studio-mode-enable"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from help" -f -a "studio-mode-disable"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from help" -f -a "studio-mode-toggle"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from help" -f -a "studio-mode-transition"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from help" -f -a "preview-current"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from help" -f -a "preview-set"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-collection; and not __fish_seen_subcommand_from current list create switch help" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-collection; and not __fish_seen_subcommand_from current list create switch help" -f -a "current"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-collection; and not __fish_seen_subcommand_from current list create switch help" -f -a "list"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-collection; and not __fish_seen_subcommand_from current list create switch help" -f -a "create"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-collection; and not __fish_seen_subcommand_from current list create switch help" -f -a "switch"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-collection; and not __fish_seen_subcommand_from current list create switch help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-collection; and __fish_seen_subcommand_from current" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-collection; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-collection; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-collection; and __fish_seen_subcommand_from switch" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-collection; and __fish_seen_subcommand_from help" -f -a "current"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-collection; and __fish_seen_subcommand_from help" -f -a "list"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-collection; and __fish_seen_subcommand_from help" -f -a "create"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-collection; and __fish_seen_subcommand_from help" -f -a "switch"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-collection; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand profile; and not __fish_seen_subcommand_from current list create remove switch help" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand profile; and not __fish_seen_subcommand_from current list create remove switch help" -f -a "current"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand profile; and not __fish_seen_subcommand_from current list create remove switch help" -f -a "list"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand profile; and not __fish_seen_subcommand_from current list create remove switch help" -f -a "create"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand profile; and not __fish_seen_subcommand_from current list create remove switch help" -f -a "remove"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand profile; and not __fish_seen_subcommand_from current list create remove switch help" -f -a "switch"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand profile; and not __fish_seen_subcommand_from current list create remove switch help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand profile; and __fish_seen_subcommand_from current" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand profile; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand profile; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand profile; and __fish_seen_subcommand_from remove" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand profile; and __fish_seen_subcommand_from switch" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand profile; and __fish_seen_subcommand_from help" -f -a "current"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand profile; and __fish_seen_subcommand_from help" -f -a "list"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand profile; and __fish_seen_subcommand_from help" -f -a "create"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand profile; and __fish_seen_subcommand_from help" -f -a "remove"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand profile; and __fish_seen_subcommand_from help" -f -a "switch"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand profile; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand video-settings; and not __fish_seen_subcommand_from get set help" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand video-settings; and not __fish_seen_subcommand_from get set help" -f -a "get"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand video-settings; and not __fish_seen_subcommand_from get set help" -f -a "set"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand video-settings; and not __fish_seen_subcommand_from get set help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand video-settings; and __fish_seen_subcommand_from get" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand video-settings; and __fish_seen_subcommand_from set" -l base-width -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand video-settings; and __fish_seen_subcommand_from set" -l base-height -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand video-settings; and __fish_seen_subcommand_from set" -l output-width -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand video-settings; and __fish_seen_subcommand_from set" -l output-height -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand video-settings; and __fish_seen_subcommand_from set" -l fps-num -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand video-settings; and __fish_seen_subcommand_from set" -l fps-den -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand video-settings; and __fish_seen_subcommand_from set" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand video-settings; and __fish_seen_subcommand_from help" -f -a "get"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand video-settings; and __fish_seen_subcommand_from help" -f -a "set"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand video-settings; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand stream-service; and not __fish_seen_subcommand_from get set help" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand stream-service; and not __fish_seen_subcommand_from get set help" -f -a "get"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand stream-service; and not __fish_seen_subcommand_from get set help" -f -a "set"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand stream-service; and not __fish_seen_subcommand_from get set help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand stream-service; and __fish_seen_subcommand_from get" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand stream-service; and __fish_seen_subcommand_from set" -l service-type -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand stream-service; and __fish_seen_subcommand_from set" -l server -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand stream-service; and __fish_seen_subcommand_from set" -l key -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand stream-service; and __fish_seen_subcommand_from set" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand stream-service; and __fish_seen_subcommand_from help" -f -a "get"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand stream-service; and __fish_seen_subcommand_from help" -f -a "set"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand stream-service; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand record-directory; and not __fish_seen_subcommand_from get set help" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand record-directory; and not __fish_seen_subcommand_from get set help" -f -a "get"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand record-directory; and not __fish_seen_subcommand_from get set help" -f -a "set"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand record-directory; and not __fish_seen_subcommand_from get set help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand record-directory; and __fish_seen_subcommand_from get" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand record-directory; and __fish_seen_subcommand_from set" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand record-directory; and __fish_seen_subcommand_from help" -f -a "get"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand record-directory; and __fish_seen_subcommand_from help" -f -a "set"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand record-directory; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand replay; and not __fish_seen_subcommand_from start stop toggle save status last-replay help" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand replay; and not __fish_seen_subcommand_from start stop toggle save status last-replay help" -f -a "start"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand replay; and not __fish_seen_subcommand_from start stop toggle save status last-replay help" -f -a "stop"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand replay; and not __fish_seen_subcommand_from start stop toggle save status last-replay help" -f -a "toggle"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand replay; and not __fish_seen_subcommand_from start stop toggle save status last-replay help" -f -a "save"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand replay; and not __fish_seen_subcommand_from start stop toggle save status last-replay help" -f -a "status"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand replay; and not __fish_seen_subcommand_from start stop toggle save status last-replay help" -f -a "last-replay"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand replay; and not __fish_seen_subcommand_from start stop toggle save status last-replay help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand replay; and __fish_seen_subcommand_from start" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand replay; and __fish_seen_subcommand_from stop" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand replay; and __fish_seen_subcommand_from toggle" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand replay; and __fish_seen_subcommand_from save" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand replay; and __fish_seen_subcommand_from status" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand replay; and __fish_seen_subcommand_from last-replay" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand replay; and __fish_seen_subcommand_from help" -f -a "start"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand replay; and __fish_seen_subcommand_from help" -f -a "stop"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand replay; and __fish_seen_subcommand_from help" -f -a "toggle"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand replay; and __fish_seen_subcommand_from help" -f -a "save"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand replay; and __fish_seen_subcommand_from help" -f -a "status"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand replay; and __fish_seen_subcommand_from help" -f -a "last-replay"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand replay; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand virtual-camera; and not __fish_seen_subcommand_from start stop toggle help" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand virtual-camera; and not __fish_seen_subcommand_from start stop toggle help" -f -a "start"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand virtual-camera; and not __fish_seen_subcommand_from start stop toggle help" -f -a "stop"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand virtual-camera; and not __fish_seen_subcommand_from start stop toggle help" -f -a "toggle"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand virtual-camera; and not __fish_seen_subcommand_from start stop toggle help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand virtual-camera; and __fish_seen_subcommand_from start" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand virtual-camera; and __fish_seen_subcommand_from stop" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand virtual-camera; and __fish_seen_subcommand_from toggle" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand virtual-camera; and __fish_seen_subcommand_from help" -f -a "start"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand virtual-camera; and __fish_seen_subcommand_from help" -f -a "stop"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand virtual-camera; and __fish_seen_subcommand_from help" -f -a "toggle"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand virtual-camera; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand streaming; and not __fish_seen_subcommand_from start stop status toggle help" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand streaming; and not __fish_seen_subcommand_from start stop status toggle help" -f -a "start"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand streaming; and not __fish_seen_subcommand_from start stop status toggle help" -f -a "stop"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand streaming; and not __fish_seen_subcommand_from start stop status toggle help" -f -a "status"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand streaming; and not __fish_seen_subcommand_from start stop status toggle help" -f -a "toggle"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand streaming; and not __fish_seen_subcommand_from start stop status toggle help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand streaming; and __fish_seen_subcommand_from start" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand streaming; and __fish_seen_subcommand_from stop" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand streaming; and __fish_seen_subcommand_from status" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand streaming; and __fish_seen_subcommand_from toggle" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand streaming; and __fish_seen_subcommand_from help" -f -a "start"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand streaming; and __fish_seen_subcommand_from help" -f -a "stop"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand streaming; and __fish_seen_subcommand_from help" -f -a "status"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand streaming; and __fish_seen_subcommand_from help" -f -a "toggle"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand streaming; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and not __fish_seen_subcommand_from start stop toggle status status-active pause resume toggle-pause create-chapter help" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and not __fish_seen_subcommand_from start stop toggle status status-active pause resume toggle-pause create-chapter help" -f -a "start"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and not __fish_seen_subcommand_from start stop toggle status status-active pause resume toggle-pause create-chapter help" -f -a "stop"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and not __fish_seen_subcommand_from start stop toggle status status-active pause resume toggle-pause create-chapter help" -f -a "toggle"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and not __fish_seen_subcommand_from start stop toggle status status-active pause resume toggle-pause create-chapter help" -f -a "status"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and not __fish_seen_subcommand_from start stop toggle status status-active pause resume toggle-pause create-chapter help" -f -a "status-active"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and not __fish_seen_subcommand_from start stop toggle status status-active pause resume toggle-pause create-chapter help" -f -a "pause"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and not __fish_seen_subcommand_from start stop toggle status status-active pause resume toggle-pause create-chapter help" -f -a "resume"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and not __fish_seen_subcommand_from start stop toggle status status-active pause resume toggle-pause create-chapter help" -f -a "toggle-pause"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and not __fish_seen_subcommand_from start stop toggle status status-active pause resume toggle-pause create-chapter help" -f -a "create-chapter"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and not __fish_seen_subcommand_from start stop toggle status status-active pause resume toggle-pause create-chapter help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and __fish_seen_subcommand_from start" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and __fish_seen_subcommand_from stop" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and __fish_seen_subcommand_from toggle" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and __fish_seen_subcommand_from status" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and __fish_seen_subcommand_from status-active" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and __fish_seen_subcommand_from pause" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and __fish_seen_subcommand_from resume" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and __fish_seen_subcommand_from toggle-pause" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and __fish_seen_subcommand_from create-chapter" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and __fish_seen_subcommand_from help" -f -a "start"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and __fish_seen_subcommand_from help" -f -a "stop"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and __fish_seen_subcommand_from help" -f -a "toggle"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and __fish_seen_subcommand_from help" -f -a "status"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and __fish_seen_subcommand_from help" -f -a "status-active"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and __fish_seen_subcommand_from help" -f -a "pause"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and __fish_seen_subcommand_from help" -f -a "resume"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and __fish_seen_subcommand_from help" -f -a "toggle-pause"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and __fish_seen_subcommand_from help" -f -a "create-chapter"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand recording; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand save-screenshot" -l width -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand save-screenshot" -l height -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand save-screenshot" -l compression-quality -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand save-screenshot" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand audio" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand filter" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and not __fish_seen_subcommand_from list create remove duplicate enable disable toggle lock unlock get-transform set-transform get-index set-index get-blend-mode set-blend-mode help" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and not __fish_seen_subcommand_from list create remove duplicate enable disable toggle lock unlock get-transform set-transform get-index set-index get-blend-mode set-blend-mode help" -f -a "list" -d 'List all scene items in a scene'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and not __fish_seen_subcommand_from list create remove duplicate enable disable toggle lock unlock get-transform set-transform get-index set-index get-blend-mode set-blend-mode help" -f -a "create" -d 'Create a new scene item from a source'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and not __fish_seen_subcommand_from list create remove duplicate enable disable toggle lock unlock get-transform set-transform get-index set-index get-blend-mode set-blend-mode help" -f -a "remove" -d 'Remove a scene item from a scene'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and not __fish_seen_subcommand_from list create remove duplicate enable disable toggle lock unlock get-transform set-transform get-index set-index get-blend-mode set-blend-mode help" -f -a "duplicate" -d 'Duplicate a scene item in a scene'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and not __fish_seen_subcommand_from list create remove duplicate enable disable toggle lock unlock get-transform set-transform get-index set-index get-blend-mode set-blend-mode help" -f -a "enable" -d 'Enable or disable a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and not __fish_seen_subcommand_from list create remove duplicate enable disable toggle lock unlock get-transform set-transform get-index set-index get-blend-mode set-blend-mode help" -f -a "disable" -d 'Disable a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and not __fish_seen_subcommand_from list create remove duplicate enable disable toggle lock unlock get-transform set-transform get-index set-index get-blend-mode set-blend-mode help" -f -a "toggle" -d 'Toggle a scene item\'s enabled state'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and not __fish_seen_subcommand_from list create remove duplicate enable disable toggle lock unlock get-transform set-transform get-index set-index get-blend-mode set-blend-mode help" -f -a "lock" -d 'Lock a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and not __fish_seen_subcommand_from list create remove duplicate enable disable toggle lock unlock get-transform set-transform get-index set-index get-blend-mode set-blend-mode help" -f -a "unlock" -d 'Unlock a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and not __fish_seen_subcommand_from list create remove duplicate enable disable toggle lock unlock get-transform set-transform get-index set-index get-blend-mode set-blend-mode help" -f -a "get-transform" -d 'Get transform info of a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and not __fish_seen_subcommand_from list create remove duplicate enable disable toggle lock unlock get-transform set-transform get-index set-index get-blend-mode set-blend-mode help" -f -a "set-transform" -d 'Set transform info of a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and not __fish_seen_subcommand_from list create remove duplicate enable disable toggle lock unlock get-transform set-transform get-index set-index get-blend-mode set-blend-mode help" -f -a "get-index" -d 'Get the index position of a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and not __fish_seen_subcommand_from list create remove duplicate enable disable toggle lock unlock get-transform set-transform get-index set-index get-blend-mode set-blend-mode help" -f -a "set-index" -d 'Set the index position of a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and not __fish_seen_subcommand_from list create remove duplicate enable disable toggle lock unlock get-transform set-transform get-index set-index get-blend-mode set-blend-mode help" -f -a "get-blend-mode" -d 'Get the blend mode of a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and not __fish_seen_subcommand_from list create remove duplicate enable disable toggle lock unlock get-transform set-transform get-index set-index get-blend-mode set-blend-mode help" -f -a "set-blend-mode" -d 'Set the blend mode of a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and not __fish_seen_subcommand_from list create remove duplicate enable disable toggle lock unlock get-transform set-transform get-index set-index get-blend-mode set-blend-mode help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from create" -l enabled -r -f -a "true\t''
false\t''"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from remove" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from duplicate" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from enable" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from disable" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from toggle" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from lock" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from unlock" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from get-transform" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from set-transform" -l position-x -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from set-transform" -l position-y -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from set-transform" -l scale-x -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from set-transform" -l scale-y -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from set-transform" -l rotation -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from set-transform" -l crop-left -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from set-transform" -l crop-right -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from set-transform" -l crop-top -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from set-transform" -l crop-bottom -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from set-transform" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from get-index" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from set-index" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from get-blend-mode" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from set-blend-mode" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from help" -f -a "list" -d 'List all scene items in a scene'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from help" -f -a "create" -d 'Create a new scene item from a source'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from help" -f -a "remove" -d 'Remove a scene item from a scene'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from help" -f -a "duplicate" -d 'Duplicate a scene item in a scene'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from help" -f -a "enable" -d 'Enable or disable a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from help" -f -a "disable" -d 'Disable a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from help" -f -a "toggle" -d 'Toggle a scene item\'s enabled state'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from help" -f -a "lock" -d 'Lock a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from help" -f -a "unlock" -d 'Unlock a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from help" -f -a "get-transform" -d 'Get transform info of a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from help" -f -a "set-transform" -d 'Set transform info of a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from help" -f -a "get-index" -d 'Get the index position of a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from help" -f -a "set-index" -d 'Set the index position of a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from help" -f -a "get-blend-mode" -d 'Get the blend mode of a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from help" -f -a "set-blend-mode" -d 'Set the blend mode of a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand scene-item; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand trigger-hotkey" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand fullscreen-projector" -l monitor-index -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand fullscreen-projector" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand source-projector" -l monitor-index -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand source-projector" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand media-input; and not __fish_seen_subcommand_from set-cursor play pause stop restart help" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand media-input; and not __fish_seen_subcommand_from set-cursor play pause stop restart help" -f -a "set-cursor" -d 'Sets the cursor of the media input'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand media-input; and not __fish_seen_subcommand_from set-cursor play pause stop restart help" -f -a "play" -d 'Starts playing the media input'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand media-input; and not __fish_seen_subcommand_from set-cursor play pause stop restart help" -f -a "pause" -d 'Pauses the media input'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand media-input; and not __fish_seen_subcommand_from set-cursor play pause stop restart help" -f -a "stop" -d 'Stops the media input'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand media-input; and not __fish_seen_subcommand_from set-cursor play pause stop restart help" -f -a "restart" -d 'Restarts the media input'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand media-input; and not __fish_seen_subcommand_from set-cursor play pause stop restart help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand media-input; and __fish_seen_subcommand_from set-cursor" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand media-input; and __fish_seen_subcommand_from play" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand media-input; and __fish_seen_subcommand_from pause" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand media-input; and __fish_seen_subcommand_from stop" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand media-input; and __fish_seen_subcommand_from restart" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand media-input; and __fish_seen_subcommand_from help" -f -a "set-cursor" -d 'Sets the cursor of the media input'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand media-input; and __fish_seen_subcommand_from help" -f -a "play" -d 'Starts playing the media input'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand media-input; and __fish_seen_subcommand_from help" -f -a "pause" -d 'Pauses the media input'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand media-input; and __fish_seen_subcommand_from help" -f -a "stop" -d 'Stops the media input'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand media-input; and __fish_seen_subcommand_from help" -f -a "restart" -d 'Restarts the media input'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand media-input; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and not __fish_seen_subcommand_from list list-kinds create remove rename settings volume mute audio-balance audio-sync-offset audio-monitor-type audio-tracks default-settings specials help" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and not __fish_seen_subcommand_from list list-kinds create remove rename settings volume mute audio-balance audio-sync-offset audio-monitor-type audio-tracks default-settings specials help" -f -a "list" -d 'List all inputs, optionally filtered by kind'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and not __fish_seen_subcommand_from list list-kinds create remove rename settings volume mute audio-balance audio-sync-offset audio-monitor-type audio-tracks default-settings specials help" -f -a "list-kinds" -d 'List all available input kinds'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and not __fish_seen_subcommand_from list list-kinds create remove rename settings volume mute audio-balance audio-sync-offset audio-monitor-type audio-tracks default-settings specials help" -f -a "create" -d 'Create a new input'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and not __fish_seen_subcommand_from list list-kinds create remove rename settings volume mute audio-balance audio-sync-offset audio-monitor-type audio-tracks default-settings specials help" -f -a "remove" -d 'Remove an input'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and not __fish_seen_subcommand_from list list-kinds create remove rename settings volume mute audio-balance audio-sync-offset audio-monitor-type audio-tracks default-settings specials help" -f -a "rename" -d 'Rename an input'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and not __fish_seen_subcommand_from list list-kinds create remove rename settings volume mute audio-balance audio-sync-offset audio-monitor-type audio-tracks default-settings specials help" -f -a "settings" -d 'Get or set input settings'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and not __fish_seen_subcommand_from list list-kinds create remove rename settings volume mute audio-balance audio-sync-offset audio-monitor-type audio-tracks default-settings specials help" -f -a "volume" -d 'Get or set input volume'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and not __fish_seen_subcommand_from list list-kinds create remove rename settings volume mute audio-balance audio-sync-offset audio-monitor-type audio-tracks default-settings specials help" -f -a "mute" -d 'Mute control for input'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and not __fish_seen_subcommand_from list list-kinds create remove rename settings volume mute audio-balance audio-sync-offset audio-monitor-type audio-tracks default-settings specials help" -f -a "audio-balance" -d 'Get or set audio balance'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and not __fish_seen_subcommand_from list list-kinds create remove rename settings volume mute audio-balance audio-sync-offset audio-monitor-type audio-tracks default-settings specials help" -f -a "audio-sync-offset" -d 'Get or set audio sync offset'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and not __fish_seen_subcommand_from list list-kinds create remove rename settings volume mute audio-balance audio-sync-offset audio-monitor-type audio-tracks default-settings specials help" -f -a "audio-monitor-type" -d 'Get or set audio monitor type'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and not __fish_seen_subcommand_from list list-kinds create remove rename settings volume mute audio-balance audio-sync-offset audio-monitor-type audio-tracks default-settings specials help" -f -a "audio-tracks" -d 'Get or set audio tracks'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and not __fish_seen_subcommand_from list list-kinds create remove rename settings volume mute audio-balance audio-sync-offset audio-monitor-type audio-tracks default-settings specials help" -f -a "default-settings" -d 'Get default settings for input kind'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and not __fish_seen_subcommand_from list list-kinds create remove rename settings volume mute audio-balance audio-sync-offset audio-monitor-type audio-tracks default-settings specials help" -f -a "specials" -d 'Get special inputs'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and not __fish_seen_subcommand_from list list-kinds create remove rename settings volume mute audio-balance audio-sync-offset audio-monitor-type audio-tracks default-settings specials help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from list-kinds" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from create" -l scene -d 'Scene to add input to (optional)' -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from create" -l settings -d 'Input settings as JSON string (optional)' -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from remove" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from rename" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from settings" -l set -d 'Set new settings as JSON string' -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from settings" -l get -d 'Get current settings'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from settings" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from volume" -l set -d 'Set volume (0.0 to 1.0)' -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from volume" -l get -d 'Get current volume'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from volume" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from mute" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from mute" -a "mute"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from mute" -a "unmute"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from mute" -a "toggle"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from mute" -a "status"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from mute" -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from audio-balance" -l set -d 'Set balance (-1.0 to 1.0)' -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from audio-balance" -l get -d 'Get current balance'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from audio-balance" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from audio-sync-offset" -l set -d 'Set sync offset in nanoseconds' -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from audio-sync-offset" -l get -d 'Get current sync offset'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from audio-sync-offset" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from audio-monitor-type" -l set -d 'Set monitor type (none, monitorOnly, both)' -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from audio-monitor-type" -l get -d 'Get current monitor type'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from audio-monitor-type" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from audio-tracks" -l set -d 'Set audio tracks as JSON' -r
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from audio-tracks" -l get -d 'Get current audio tracks'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from audio-tracks" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from default-settings" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from specials" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from help" -f -a "list" -d 'List all inputs, optionally filtered by kind'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from help" -f -a "list-kinds" -d 'List all available input kinds'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from help" -f -a "create" -d 'Create a new input'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from help" -f -a "remove" -d 'Remove an input'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from help" -f -a "rename" -d 'Rename an input'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from help" -f -a "settings" -d 'Get or set input settings'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from help" -f -a "volume" -d 'Get or set input volume'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from help" -f -a "mute" -d 'Mute control for input'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from help" -f -a "audio-balance" -d 'Get or set audio balance'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from help" -f -a "audio-sync-offset" -d 'Get or set audio sync offset'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from help" -f -a "audio-monitor-type" -d 'Get or set audio monitor type'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from help" -f -a "audio-tracks" -d 'Get or set audio tracks'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from help" -f -a "default-settings" -d 'Get default settings for input kind'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from help" -f -a "specials" -d 'Get special inputs'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand input; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand completion" -s h -l help -d 'Print help'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and not __fish_seen_subcommand_from info scene scene-collection profile video-settings stream-service record-directory replay virtual-camera streaming recording save-screenshot audio filter scene-item trigger-hotkey fullscreen-projector source-projector media-input input completion help" -f -a "info" -d 'Get OBS Studio version and information'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and not __fish_seen_subcommand_from info scene scene-collection profile video-settings stream-service record-directory replay virtual-camera streaming recording save-screenshot audio filter scene-item trigger-hotkey fullscreen-projector source-projector media-input input completion help" -f -a "scene"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and not __fish_seen_subcommand_from info scene scene-collection profile video-settings stream-service record-directory replay virtual-camera streaming recording save-screenshot audio filter scene-item trigger-hotkey fullscreen-projector source-projector media-input input completion help" -f -a "scene-collection"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and not __fish_seen_subcommand_from info scene scene-collection profile video-settings stream-service record-directory replay virtual-camera streaming recording save-screenshot audio filter scene-item trigger-hotkey fullscreen-projector source-projector media-input input completion help" -f -a "profile"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and not __fish_seen_subcommand_from info scene scene-collection profile video-settings stream-service record-directory replay virtual-camera streaming recording save-screenshot audio filter scene-item trigger-hotkey fullscreen-projector source-projector media-input input completion help" -f -a "video-settings"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and not __fish_seen_subcommand_from info scene scene-collection profile video-settings stream-service record-directory replay virtual-camera streaming recording save-screenshot audio filter scene-item trigger-hotkey fullscreen-projector source-projector media-input input completion help" -f -a "stream-service"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and not __fish_seen_subcommand_from info scene scene-collection profile video-settings stream-service record-directory replay virtual-camera streaming recording save-screenshot audio filter scene-item trigger-hotkey fullscreen-projector source-projector media-input input completion help" -f -a "record-directory"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and not __fish_seen_subcommand_from info scene scene-collection profile video-settings stream-service record-directory replay virtual-camera streaming recording save-screenshot audio filter scene-item trigger-hotkey fullscreen-projector source-projector media-input input completion help" -f -a "replay"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and not __fish_seen_subcommand_from info scene scene-collection profile video-settings stream-service record-directory replay virtual-camera streaming recording save-screenshot audio filter scene-item trigger-hotkey fullscreen-projector source-projector media-input input completion help" -f -a "virtual-camera"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and not __fish_seen_subcommand_from info scene scene-collection profile video-settings stream-service record-directory replay virtual-camera streaming recording save-screenshot audio filter scene-item trigger-hotkey fullscreen-projector source-projector media-input input completion help" -f -a "streaming"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and not __fish_seen_subcommand_from info scene scene-collection profile video-settings stream-service record-directory replay virtual-camera streaming recording save-screenshot audio filter scene-item trigger-hotkey fullscreen-projector source-projector media-input input completion help" -f -a "recording"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and not __fish_seen_subcommand_from info scene scene-collection profile video-settings stream-service record-directory replay virtual-camera streaming recording save-screenshot audio filter scene-item trigger-hotkey fullscreen-projector source-projector media-input input completion help" -f -a "save-screenshot"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and not __fish_seen_subcommand_from info scene scene-collection profile video-settings stream-service record-directory replay virtual-camera streaming recording save-screenshot audio filter scene-item trigger-hotkey fullscreen-projector source-projector media-input input completion help" -f -a "audio"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and not __fish_seen_subcommand_from info scene scene-collection profile video-settings stream-service record-directory replay virtual-camera streaming recording save-screenshot audio filter scene-item trigger-hotkey fullscreen-projector source-projector media-input input completion help" -f -a "filter"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and not __fish_seen_subcommand_from info scene scene-collection profile video-settings stream-service record-directory replay virtual-camera streaming recording save-screenshot audio filter scene-item trigger-hotkey fullscreen-projector source-projector media-input input completion help" -f -a "scene-item"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and not __fish_seen_subcommand_from info scene scene-collection profile video-settings stream-service record-directory replay virtual-camera streaming recording save-screenshot audio filter scene-item trigger-hotkey fullscreen-projector source-projector media-input input completion help" -f -a "trigger-hotkey"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and not __fish_seen_subcommand_from info scene scene-collection profile video-settings stream-service record-directory replay virtual-camera streaming recording save-screenshot audio filter scene-item trigger-hotkey fullscreen-projector source-projector media-input input completion help" -f -a "fullscreen-projector"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and not __fish_seen_subcommand_from info scene scene-collection profile video-settings stream-service record-directory replay virtual-camera streaming recording save-screenshot audio filter scene-item trigger-hotkey fullscreen-projector source-projector media-input input completion help" -f -a "source-projector"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and not __fish_seen_subcommand_from info scene scene-collection profile video-settings stream-service record-directory replay virtual-camera streaming recording save-screenshot audio filter scene-item trigger-hotkey fullscreen-projector source-projector media-input input completion help" -f -a "media-input"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and not __fish_seen_subcommand_from info scene scene-collection profile video-settings stream-service record-directory replay virtual-camera streaming recording save-screenshot audio filter scene-item trigger-hotkey fullscreen-projector source-projector media-input input completion help" -f -a "input"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and not __fish_seen_subcommand_from info scene scene-collection profile video-settings stream-service record-directory replay virtual-camera streaming recording save-screenshot audio filter scene-item trigger-hotkey fullscreen-projector source-projector media-input input completion help" -f -a "completion" -d 'Generate shell completion scripts'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and not __fish_seen_subcommand_from info scene scene-collection profile video-settings stream-service record-directory replay virtual-camera streaming recording save-screenshot audio filter scene-item trigger-hotkey fullscreen-projector source-projector media-input input completion help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene" -f -a "current"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene" -f -a "switch"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene" -f -a "list"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene" -f -a "create"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene" -f -a "remove"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene" -f -a "rename"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene" -f -a "transition-list"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene" -f -a "transition-current"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene" -f -a "transition-set"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene" -f -a "transition-duration"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene" -f -a "transition-trigger"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene" -f -a "studio-mode-status"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene" -f -a "studio-mode-enable"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene" -f -a "studio-mode-disable"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene" -f -a "studio-mode-toggle"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene" -f -a "studio-mode-transition"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene" -f -a "preview-current"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene" -f -a "preview-set"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene-collection" -f -a "current"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene-collection" -f -a "list"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene-collection" -f -a "create"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene-collection" -f -a "switch"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from profile" -f -a "current"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from profile" -f -a "list"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from profile" -f -a "create"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from profile" -f -a "remove"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from profile" -f -a "switch"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from video-settings" -f -a "get"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from video-settings" -f -a "set"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from stream-service" -f -a "get"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from stream-service" -f -a "set"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from record-directory" -f -a "get"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from record-directory" -f -a "set"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from replay" -f -a "start"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from replay" -f -a "stop"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from replay" -f -a "toggle"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from replay" -f -a "save"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from replay" -f -a "status"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from replay" -f -a "last-replay"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from virtual-camera" -f -a "start"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from virtual-camera" -f -a "stop"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from virtual-camera" -f -a "toggle"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from streaming" -f -a "start"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from streaming" -f -a "stop"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from streaming" -f -a "status"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from streaming" -f -a "toggle"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from recording" -f -a "start"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from recording" -f -a "stop"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from recording" -f -a "toggle"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from recording" -f -a "status"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from recording" -f -a "status-active"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from recording" -f -a "pause"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from recording" -f -a "resume"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from recording" -f -a "toggle-pause"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from recording" -f -a "create-chapter"
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene-item" -f -a "list" -d 'List all scene items in a scene'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene-item" -f -a "create" -d 'Create a new scene item from a source'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene-item" -f -a "remove" -d 'Remove a scene item from a scene'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene-item" -f -a "duplicate" -d 'Duplicate a scene item in a scene'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene-item" -f -a "enable" -d 'Enable or disable a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene-item" -f -a "disable" -d 'Disable a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene-item" -f -a "toggle" -d 'Toggle a scene item\'s enabled state'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene-item" -f -a "lock" -d 'Lock a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene-item" -f -a "unlock" -d 'Unlock a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene-item" -f -a "get-transform" -d 'Get transform info of a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene-item" -f -a "set-transform" -d 'Set transform info of a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene-item" -f -a "get-index" -d 'Get the index position of a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene-item" -f -a "set-index" -d 'Set the index position of a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene-item" -f -a "get-blend-mode" -d 'Get the blend mode of a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from scene-item" -f -a "set-blend-mode" -d 'Set the blend mode of a scene item'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from media-input" -f -a "set-cursor" -d 'Sets the cursor of the media input'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from media-input" -f -a "play" -d 'Starts playing the media input'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from media-input" -f -a "pause" -d 'Pauses the media input'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from media-input" -f -a "stop" -d 'Stops the media input'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from media-input" -f -a "restart" -d 'Restarts the media input'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from input" -f -a "list" -d 'List all inputs, optionally filtered by kind'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from input" -f -a "list-kinds" -d 'List all available input kinds'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from input" -f -a "create" -d 'Create a new input'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from input" -f -a "remove" -d 'Remove an input'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from input" -f -a "rename" -d 'Rename an input'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from input" -f -a "settings" -d 'Get or set input settings'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from input" -f -a "volume" -d 'Get or set input volume'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from input" -f -a "mute" -d 'Mute control for input'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from input" -f -a "audio-balance" -d 'Get or set audio balance'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from input" -f -a "audio-sync-offset" -d 'Get or set audio sync offset'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from input" -f -a "audio-monitor-type" -d 'Get or set audio monitor type'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from input" -f -a "audio-tracks" -d 'Get or set audio tracks'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from input" -f -a "default-settings" -d 'Get default settings for input kind'
complete -c obs-cmd -n "__fish_obs_cmd_using_subcommand help; and __fish_seen_subcommand_from input" -f -a "specials" -d 'Get special inputs'
