{ config, lib, pkgs, ... }:
{
  imports = [ 
    ./hypr-env.nix
  ];

  programs.kitty.enable = true; # required for the default Hyprland config
  wayland.windowManager.hyprland.enable = true; # enable Hyprland

  # Optional, hint Electron apps to use Wayland:
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  wayland.windowManager.hyprland = {
    systemd.enable = true;

    settings = {
      "$mod" = "SUPER";
      bind =
        [
          "$mod, F, exec, firefox"
          "$mod, T, exec, alacritty"
          "$mod SHIFT, Q, killactive"
          "$mod, M, exit"
          "$mod, w, exec, wofi --show drun"
          "$mod, G, fullscreen"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (i:
              let ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );
    };
    extraConfig = ''
      monitor=eDP-1,1920x1080@165,0x0,1.2

      exec-once = hyprctl setcursor Bibata-Modern-Classic 24
      exec-once = swww-daemon 
      exec = pkill waybar & sleep 0.5 && waybar 
      exec-once = dunst

    general {

        gaps_in = 5
        gaps_out = 10
        border_size = 1
        col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
        col.inactive_border = rgba(595959aa)

        layout = dwindle
    }

    decoration {

        rounding = 0

        drop_shadow = true
        shadow_range = 4
        shadow_render_power = 3
        col.shadow = rgba(1a1a1aee)
    }


    animations {
        enabled = yes

        bezier = ease,0.4,0.02,0.21,1

        animation = windows, 1, 3.5, ease, slide
        animation = windowsOut, 1, 3.5, ease, slide
        animation = border, 1, 6, default
        animation = fade, 1, 3, ease
        animation = workspaces, 1, 3.5, ease
    }

    dwindle {
        pseudotile = yes
        preserve_split = yes
    }

    gestures {
        workspace_swipe = false
    }

    # Functional keybinds
    bind =,XF86AudioMicMute,exec,pamixer --default-source -t
    bind =,XF86MonBrightnessDown,exec,light -U 20
    bind =,XF86MonBrightnessUp,exec,light -A 20
    bind =,XF86AudioMute,exec,pamixer -t
    bind =,XF86AudioLowerVolume,exec,pamixer -d 10
    bind =,XF86AudioRaiseVolume,exec,pamixer -i 10
    bind =,XF86AudioPlay,exec,playerctl play-pause
    bind =,XF86AudioPause,exec,playerctl play-pause

misc {
       disable_splash_rendering = true
    disable_hyprland_logo = true
}
    '';
  };


  home.packages = with pkgs; [ 
    waybar
    swww
  ];

}
