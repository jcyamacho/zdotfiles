# .NET SDK (developer platform): https://dotnet.microsoft.com/

(( $+_dotnet_plugin_dir )) || typeset -gr _dotnet_plugin_dir="$ZDOTFILES_DIR/plugins/dotnet"

builtin source "$_dotnet_plugin_dir/dotnet-sdk.zsh"

exists dotnet && builtin source "$_dotnet_plugin_dir/dotnet-tools.zsh"
