alias vi="nvim"


# ===================================
# Chezmoi wrapper
# ===================================
chezmoi() {
    case "$1" in
        push)
            # Kiểm tra xem chezmoi đã có lệnh `push` native chưa
            if command chezmoi push --help &>/dev/null; then
                echo -e "\033[1;33m[WARNING] Chezmoi đã có lệnh 'push' native! Đang chuyển sang lệnh hệ thống...\033[0m"
                command chezmoi "$@"
            else
                shift # Bỏ tham số "push"
                local msg="${1:-Update dotfiles}"
                command chezmoi git add . && \
                command chezmoi git -- commit -m "$msg" && \
                command chezmoi git push
            fi
            ;;
        *)
            command chezmoi "$@"
            ;;
    esac
}
