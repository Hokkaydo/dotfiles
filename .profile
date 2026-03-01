

# Added by Toolbox App
export PATH="$PATH:/home/hokkaydo/.local/share/JetBrains/Toolbox/scripts"
export DEBUGINFOD_URLS="https://debuginfod.archlinux.org"

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

case ":$PATH:" in
    *:/home/hokkaydo/.juliaup/bin:*)
        ;;

    *)
        export PATH=/home/hokkaydo/.juliaup/bin${PATH:+:${PATH}}
        ;;
esac

# <<< juliaup initialize <<<
