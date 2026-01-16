if type -q exa
  alias ll "exa -l -g --icons"
  alias lla "ll -a"
end

if status is-interactive
    eval (/opt/homebrew/bin/brew shellenv)
    zoxide init fish | source
    set -gx PATH "$HOME/.cargo/bin" $PATH;
    set -fx PATH "$(go env GOPATH)/bin" $PATH;
    fish_user_key_bindings
    alias g "git"
end

function fish_user_key_bindings
    fish_vi_key_bindings
end

function fish_prompt
  set -l pwd_components (string split / $PWD)
  set pwd_components_count (count $pwd_components)
  if test $pwd_components_count -ge 2;
    set -x head_directory (echo "$pwd_components[-1]")
  else;
    set -x head_directory (echo "$pwd_components[-1]")
  end
  if test "$hostname" = "lcolli1223mac";
    echo (set_color yellow)"$(date '+%H:%M:%S') "(set_color normal)"/$head_directory "
  else;
    echo (set_color yellow)"$(date '+%H:%M:%S') "(set_color green)"$hostname"(set_color normal)"/$head_directory "
  end
end

function fish_mode_prompt 
end





# >>> JVM installed by coursier >>>
set -gx JAVA_HOME "/Users/lukecollier/Library/Caches/Coursier/arc/https/github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.9%252B10/OpenJDK21U-jdk_x64_mac_hotspot_21.0.9_10.tar.gz/jdk-21.0.9+10/Contents/Home"
# <<< JVM installed by coursier <<<


# >>> coursier install directory >>>
set -gx PATH "$PATH:/Users/lukecollier/Library/Application Support/Coursier/bin"
# <<< coursier install directory <<<
