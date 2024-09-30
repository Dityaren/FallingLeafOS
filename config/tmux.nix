{ pkgs,  ... }:
{
  programs.tmux = {
    enable = true;
	  clock24 = true;
	  plugins = with pkgs.tmuxPlugins; [
		  sensible
		  yank
		  {
			  plugin = catppuccin;
			  extraConfig = ''
          set -g @catppuccin_window_left_separator "█"
          set -g base-index 1
          setw -g pane-base-index 1
			  '';
		  }
	  ];

	  extraConfig = ''
		set -g mouse on
	  '';

  };
}
